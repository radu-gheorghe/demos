#!/usr/bin/env python3
"""Turn the file list into source_file and passage feed operations.

Chunks stay near 1.6k characters so bge-small (512 tokens) sees the whole passage.
Code identifiers are not split here; the Lucene code profile does that.
"""

import argparse
import json
import os
import posixpath
import re
import sys
from collections import defaultdict
from html.parser import HTMLParser

MAX_LINES = 80
MAX_CHARS = 1600
OVERLAP_LINES = 8
MIN_CHARS = 40
MAX_LINKS = 24
MAX_SYMBOLS = 64

INCLUDE_RE = re.compile(r'^\s*#\s*include\s*[<"]([^>"]+)[>"]', re.M)
MD_LINK_RE = re.compile(r'\[[^\]]*\]\(([^)\s]+)\)')
IMPORT_RE = re.compile(r'^\s*import\s+(?:static\s+)?([A-Za-z_][\w.]*)\s*;', re.M)
DOC_TYPE_RE = re.compile(r'<document\b[^>]*\btype="([^"]+)"')
DECL_RE = re.compile(
    r'\b(class|interface|enum|record|rank-profile|document-summary|field|struct|def)\s+([A-Za-z_][\w]*)'
)
DECL_RANK = {
    "class": 0, "interface": 1, "enum": 2, "record": 3,
    "rank-profile": 4, "document-summary": 5, "field": 6, "struct": 7, "def": 8,
}
HEADING_RE = re.compile(r'^(#{1,6})\s+(.*?)\s*#*\s*$')
SD_DECL_RE = re.compile(
    r'^\s*(field|rank-profile|document-summary|struct|fieldset|annotation|constant)\b'
)
PY_DECL_RE = re.compile(r'^(?:async\s+def|def|class)\s+')

CLANG = {"java", "cpp", "c"}
HASHLANG = {"python", "sd"}


def file_id(repo, path):
    return f"id:corpus:source_file::{repo}/{path}"


def passage_id(repo, path, ordinal):
    return f"id:corpus:passage::{repo}/{path}#{ordinal}"


def read_text(path):
    with open(path, "rb") as fh:
        data = fh.read()
    if b"\0" in data:
        return None
    try:
        return data.decode("utf-8")
    except UnicodeDecodeError:
        return data.decode("latin-1")


def scan_line(line, depth, in_block):
    i = 0
    n = len(line)
    while i < n:
        if in_block:
            end = line.find("*/", i)
            if end < 0:
                return depth, True
            in_block = False
            i = end + 2
            continue
        if line.startswith("//", i):
            break
        if line.startswith("/*", i):
            in_block = True
            i += 2
            continue
        ch = line[i]
        if ch in "'\"":
            i += 1
            while i < n:
                if line[i] == "\\":
                    i += 2
                    continue
                if line[i] == ch:
                    i += 1
                    break
                i += 1
            continue
        if ch == "{":
            depth += 1
        elif ch == "}":
            depth = max(0, depth - 1)
        i += 1
    return depth, in_block


def brace_units(lines):
    units = []
    depth = 0
    unit_start = None
    preamble = 0
    in_block = False
    for idx, line in enumerate(lines):
        before = depth
        depth, in_block = scan_line(line, depth, in_block)
        if unit_start is None and before == 0 and depth > 0:
            if idx > preamble and any(l.strip() for l in lines[preamble:idx]):
                units.append((preamble, idx))
            unit_start = idx
        if unit_start is not None and before > 0 and depth == 0:
            units.append((unit_start, idx + 1))
            unit_start = None
            preamble = idx + 1
    if unit_start is not None:
        units.append((unit_start, len(lines)))
    elif preamble < len(lines) and any(l.strip() for l in lines[preamble:]):
        units.append((preamble, len(lines)))
    return units or [(0, len(lines))]


def sd_units(lines):
    units = []
    depth = 0
    start = 0
    in_block = False
    for idx, line in enumerate(lines):
        if depth == 1 and SD_DECL_RE.match(line) and idx > start:
            units.append((start, idx))
            start = idx
        depth, in_block = scan_line(line, depth, in_block)
    if start < len(lines):
        units.append((start, len(lines)))
    return units or [(0, len(lines))]


def python_units(lines):
    idxs = [i for i, line in enumerate(lines) if PY_DECL_RE.match(line)]
    if not idxs:
        return [(0, len(lines))]
    units = []
    if idxs[0] > 0:
        units.append((0, idxs[0]))
    for start, end in zip(idxs, idxs[1:] + [len(lines)]):
        units.append((start, end))
    return units


def strip_markdown_front_matter(text):
    lines = text.splitlines()
    i = 0
    while i < len(lines) and (not lines[i].strip() or lines[i].startswith("# Copyright")):
        i += 1
    if i < len(lines) and lines[i].strip() == "---":
        end = i + 1
        while end < len(lines) and lines[end].strip() != "---":
            end += 1
        if end < len(lines):
            i = end + 1
    return "\n".join(lines[i:]), i


def markdown_units(lines):
    units = []
    stack = []
    start = 0
    path = []
    for idx, line in enumerate(lines):
        match = HEADING_RE.match(line)
        if not match:
            continue
        if idx > start:
            units.append((start, idx, list(path)))
        level = len(match.group(1))
        title = match.group(2).strip()
        while stack and stack[-1][0] >= level:
            stack.pop()
        stack.append((level, title))
        path = [title for _, title in stack]
        start = idx
    if start < len(lines):
        units.append((start, len(lines), list(path)))
    if not units:
        units.append((0, len(lines), []))
    return units


def line_spans(lines, lo, hi):
    spans = []
    i = lo
    while i < hi:
        chars = 0
        j = i
        while j < hi and (j - i) < MAX_LINES and chars + len(lines[j]) + 1 <= MAX_CHARS:
            chars += len(lines[j]) + 1
            j += 1
        if j == i:
            j = i + 1
        spans.append((i, j))
        if j >= hi:
            break
        nxt = max(j - OVERLAP_LINES, i + 1)
        i = nxt
    return spans


def split_c_comments(text):
    prose = []
    code = []
    i = 0
    n = len(text)
    while i < n:
        if text.startswith("//", i):
            # http:// stays in the code. Treating it as a comment makes the scan stick.
            if i > 0 and text[i - 1] == ":":
                code.append("//")
                i += 2
                continue
            end = text.find("\n", i)
            if end < 0:
                end = n
            prose.append(text[i + 2:end])
            i = end
            continue
        if text.startswith("/*", i):
            end = text.find("*/", i + 2)
            if end < 0:
                prose.append(text[i + 2:])
                i = n
            else:
                prose.append(text[i + 2:end])
                i = end + 2
            continue
        nxt = n
        for marker in ("//", "/*"):
            pos = text.find(marker, i)
            if pos >= 0:
                nxt = min(nxt, pos)
        if nxt <= i:
            nxt = i + 1
        code.append(text[i:nxt])
        i = nxt
    return _clean("\n".join(prose)), _clean("".join(code))


def _clean(text):
    lines = [line.rstrip() for line in text.splitlines()]
    while lines and not lines[0].strip():
        lines.pop(0)
    while lines and not lines[-1].strip():
        lines.pop()
    return "\n".join(lines).strip()


def split_hash(text):
    prose, code = [], []
    for line in text.splitlines():
        stripped = line.lstrip()
        if stripped.startswith("#"):
            prose.append(stripped[1:].strip())
        else:
            code.append(line)
    return _clean("\n".join(prose)), _clean("\n".join(code))


def split_fences(lines):
    prose, code = [], []
    in_fence = False
    for line in lines:
        if line.startswith("```"):
            in_fence = not in_fence
            continue
        (code if in_fence else prose).append(line)
    return _clean("\n".join(prose)), _clean("\n".join(code))


def split_xml(text):
    prose = []

    def grab(match):
        prose.append(match.group(1).strip())
        return ""

    code = re.sub(r"<!--(.*?)-->", grab, text, flags=re.S)
    return _clean("\n".join(prose)), _clean(code)


class _HtmlDoc(HTMLParser):
    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.skip = 0
        self.mode = "prose"
        self.stack = []
        self.sections = []
        self.cur = {"line": 1, "path": [], "prose": [], "code": []}
        self.heading_buf = []
        self.heading_level = 0
        self.heading_line = 1

    def handle_starttag(self, tag, attrs):
        if tag in ("script", "style"):
            self.skip += 1
            return
        if self.skip:
            return
        if tag in ("h1", "h2", "h3"):
            self._close()
            self.mode = "heading"
            self.heading_level = int(tag[1])
            self.heading_line = self.getpos()[0]
            self.heading_buf = []
            return
        if tag in ("pre", "code"):
            self.mode = "code"
        if tag in ("p", "div", "li", "br", "tr", "section", "h4"):
            self.cur["prose"].append("\n")

    def handle_endtag(self, tag):
        if tag in ("script", "style") and self.skip:
            self.skip -= 1
            return
        if tag in ("h1", "h2", "h3") and self.mode == "heading":
            title = " ".join("".join(self.heading_buf).split())
            level = self.heading_level
            while self.stack and self.stack[-1][0] >= level:
                self.stack.pop()
            if title:
                self.stack.append((level, title))
            self.cur = {
                "line": self.heading_line,
                "path": [item[1] for item in self.stack],
                "prose": [],
                "code": [],
            }
            self.mode = "prose"
            return
        if tag in ("pre", "code") and self.mode == "code":
            self.mode = "prose"
            self.cur["code"].append("\n")

    def handle_data(self, data):
        if self.skip:
            return
        if self.mode == "heading":
            self.heading_buf.append(data)
        elif self.mode == "code":
            self.cur["code"].append(data)
        else:
            self.cur["prose"].append(data)

    def _close(self):
        prose = _clean("".join(self.cur["prose"]))
        code = _clean("".join(self.cur["code"]))
        if prose or code:
            self.sections.append((self.cur["line"], list(self.cur["path"]), prose, code))

    def finish(self):
        self._close()
        return self.sections


def window_labeled(text, limit):
    text = text.strip()
    if len(text) <= limit:
        return [text] if text else []
    parts = []
    start = 0
    while start < len(text):
        end = min(len(text), start + limit)
        if end < len(text):
            nl = text.rfind("\n", start + limit // 2, end)
            if nl > start:
                end = nl
        piece = text[start:end].strip()
        if piece:
            parts.append(piece)
        if end >= len(text):
            break
        start = max(end - 120, start + 1)
    return parts


def symbols_in(text):
    ranked = []
    seen = set()
    for match in DECL_RE.finditer(text):
        kind, name = match.group(1), match.group(2)
        if name in seen:
            continue
        seen.add(name)
        ranked.append((DECL_RANK[kind], name))
    ranked.sort(key=lambda item: item[0])
    return [name for _, name in ranked[:MAX_SYMBOLS]]


def kind_of(language):
    if language in ("markdown", "html"):
        return "doc"
    if language == "sd":
        return "schema"
    if language in ("xml", "def"):
        return "config"
    return "code"


def build_index(files):
    exact = {(item["repo"], item["path"]) for item in files}
    suffixes = defaultdict(list)
    for item in files:
        parts = item["path"].split("/")
        repo = item["repo"]
        for i in range(len(parts)):
            suffix = "/".join(parts[i:])
            if len(suffix) < 4:
                continue
            suffixes[(repo, suffix)].append(item["path"])
    return exact, suffixes


def resolve_links(repo, path, text, exact, suffixes):
    raw = []
    raw.extend(INCLUDE_RE.findall(text))
    raw.extend(MD_LINK_RE.findall(text))
    raw.extend(IMPORT_RE.findall(text))
    raw.extend(DOC_TYPE_RE.findall(text))
    link_paths = []
    links = []
    seen_raw = set()
    seen_ids = set()
    own = file_id(repo, path)
    for target in raw:
        target = target.strip()
        if not target or target in seen_raw:
            continue
        if target.startswith(("http://", "https://", "mailto:")):
            continue
        seen_raw.add(target)
        if len(link_paths) < MAX_LINKS:
            link_paths.append(target)
        resolved = _resolve_one(repo, path, target, exact, suffixes)
        if resolved is None:
            continue
        doc = file_id(*resolved)
        if doc == own or doc in seen_ids:
            continue
        seen_ids.add(doc)
        links.append(doc)
        if len(links) >= MAX_LINKS:
            break
    return links, link_paths


def _resolve_one(repo, path, target, exact, suffixes):
    cut = target.split("#", 1)[0].split("?", 1)[0].strip()
    if not cut:
        return None
    if "://" in cut:
        return None
    if cut.startswith("/"):
        rel = cut.lstrip("/")
        if (repo, rel) in exact:
            return repo, rel
        if rel.startswith("en/") and ("documentation", rel) in exact:
            return "documentation", rel
        return None
    if re.fullmatch(r"[A-Za-z_][\w.]*", cut) and "." in cut and "/" not in cut:
        suffix = cut.replace(".", "/") + ".java"
        hit = _unique(suffixes.get((repo, suffix)))
        if hit:
            return repo, hit
        return None
    if re.fullmatch(r"[A-Za-z_][\w]*", cut):
        for ext in (".sd", ".profile", ".xml", ".md", ".html"):
            hit = _unique(suffixes.get((repo, cut + ext)))
            if hit:
                return repo, hit
        return None
    base = posixpath.dirname(path)
    rel = posixpath.normpath(posixpath.join(base, cut))
    if (repo, rel) in exact:
        return repo, rel
    hit = _unique(suffixes.get((repo, cut.lstrip("./"))))
    if hit:
        return repo, hit
    return None


def _unique(paths):
    if paths and len(paths) == 1:
        return paths[0]
    return None


def iter_pieces(record, text):
    """Yield (start_line, end_line, heading, heading_path, prose, code, symbol)."""
    language = record["source_language"]
    lines = text.splitlines()
    if language == "markdown":
        body, skipped = strip_markdown_front_matter(text)
        lines = body.splitlines()
        for lo, hi, heading_path in markdown_units(lines):
            for start, end in line_spans(lines, lo, hi):
                prose, code = split_fences(lines[start:end])
                crumb = " > ".join(heading_path)
                if not prose and not code:
                    continue
                if crumb:
                    prose = (crumb + "\n\n" + prose).strip() if prose else crumb
                heading = heading_path[-1] if heading_path else ""
                yield start + 1 + skipped, end + skipped, heading, heading_path, prose, code, ""
        return
    if language == "html":
        parser = _HtmlDoc()
        try:
            parser.feed(text)
            parser.close()
            sections = parser.finish()
        except Exception:
            sections = [(1, [], _clean(re.sub(r"<[^>]+>", " ", text)), "")]
        for line_no, heading_path, prose, code in sections:
            crumb = " > ".join(heading_path)
            bodies = _pair_windows(prose, code)
            for prose_i, code_i in bodies:
                if crumb and prose_i:
                    prose_i = crumb + "\n\n" + prose_i
                elif crumb and not prose_i:
                    prose_i = crumb
                heading = heading_path[-1] if heading_path else ""
                yield line_no, line_no, heading, heading_path, prose_i, code_i, ""
        return

    if language == "python":
        units = python_units(lines)
    elif language == "sd":
        units = sd_units(lines)
    elif language in CLANG or language == "xml":
        units = brace_units(lines) if language in CLANG else [(0, len(lines))]
    else:
        units = [(0, len(lines))]

    for lo, hi in units:
        sig = ""
        for line in lines[lo:hi]:
            if line.strip():
                sig = line.strip()[:200]
                break
        spans = line_spans(lines, lo, hi)
        for nth, (start, end) in enumerate(spans):
            chunk = "\n".join(lines[start:end])
            names = symbols_in(chunk)
            symbol = names[0] if names else ""
            prose, code = split_chunk(language, chunk)
            if nth > 0 and sig and sig not in code[: len(sig) + 5]:
                code = sig + "\n" + code if code else sig
            yield start + 1, end, symbol, [symbol] if symbol else [], prose, code, symbol


def split_chunk(language, chunk):
    if language in CLANG:
        return split_c_comments(chunk)
    if language in HASHLANG:
        return split_hash(chunk)
    if language == "xml":
        return split_xml(chunk)
    return "", _clean(chunk)


def _pair_windows(prose, code):
    prose_parts = window_labeled(prose, MAX_CHARS) or [""]
    code_parts = window_labeled(code, MAX_CHARS) or [""]
    if prose_parts == [""] and code_parts == [""]:
        return []
    count = max(len(prose_parts), len(code_parts))
    pairs = []
    for i in range(count):
        pairs.append((
            prose_parts[i] if i < len(prose_parts) else "",
            code_parts[i] if i < len(code_parts) else "",
        ))
    return pairs


def passages_for(record, text, exact, suffixes):
    repo = record["repo"]
    path = record["path"]
    language = record["source_language"]
    fid = file_id(repo, path)
    context = f"{repo}/{path}"
    ordinal = 0
    for start, end, heading, heading_path, prose, code, symbol in iter_pieces(record, text):
        prose = prose.strip()
        code = code.strip()
        if len(prose) + len(code) < MIN_CHARS:
            continue
        if context not in code:
            code = (context + (f" {symbol}" if symbol else "") + "\n" + code).strip()
        if len(prose) > MAX_CHARS:
            prose = prose[:MAX_CHARS]
        if len(code) > MAX_CHARS:
            code = code[:MAX_CHARS]
        blob = prose + "\n" + code
        links, link_paths = resolve_links(repo, path, blob, exact, suffixes)
        fields = {
            "file": fid,
            "parents": [fid],
            "repo": repo,
            "path": path,
            "source_language": language,
            "kind": kind_of(language),
            "start_line": start,
            "end_line": end,
            "language": "en",
            "prose": prose,
            "code": code,
        }
        if links:
            fields["links"] = links
        if link_paths:
            fields["link_paths"] = link_paths
        if symbol:
            fields["symbol"] = symbol
        if heading:
            fields["heading"] = heading
        if heading_path:
            fields["heading_path"] = [part for part in heading_path if part]
        yield {
            "id": passage_id(repo, path, ordinal),
            "fields": fields,
        }
        ordinal += 1


def source_doc(record, text):
    return {
        "id": file_id(record["repo"], record["path"]),
        "fields": {
            "repo": record["repo"],
            "path": record["path"],
            "source_language": record["source_language"],
            "symbols": symbols_in(text),
            "byte_size": record["byte_size"],
        },
    }


def main():
    parser = argparse.ArgumentParser(description="Chunk selected files into feed JSONL")
    parser.add_argument("--files", required=True, help="JSONL from select_files.py")
    parser.add_argument("--sources", required=True)
    parser.add_argument("--passages", required=True)
    args = parser.parse_args()

    files = []
    with open(args.files, encoding="utf-8") as fh:
        for line in fh:
            line = line.strip()
            if line:
                files.append(json.loads(line))
    exact, suffixes = build_index(files)
    os.makedirs(os.path.dirname(os.path.abspath(args.sources)), exist_ok=True)
    n_src = n_pass = 0
    with open(args.sources, "w", encoding="utf-8") as sources, open(args.passages, "w", encoding="utf-8") as passages:
        for record in files:
            text = read_text(record["abs"])
            if text is None:
                continue
            sources.write(json.dumps(source_doc(record, text), ensure_ascii=False) + "\n")
            n_src += 1
            for doc in passages_for(record, text, exact, suffixes):
                passages.write(json.dumps(doc, ensure_ascii=False) + "\n")
                n_pass += 1
            if n_src % 500 == 0:
                print(f"chunked {n_src} files, {n_pass} passages", file=sys.stderr, flush=True)
    print(f"chunked {n_src} files, {n_pass} passages", file=sys.stderr)
    return 0


if __name__ == "__main__":
    sys.exit(main())
