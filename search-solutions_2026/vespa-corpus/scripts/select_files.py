#!/usr/bin/env python3
"""List source files to index. Reads the three checkouts; writes JSON lines."""

import argparse
import json
import os
import sys
from pathlib import Path

# This file is vespa-corpus/scripts/select_files.py. parents[2] is the repo root.
REPO = Path(__file__).resolve().parents[2]
ROOTS = {
    "vespa": REPO / "git-checkouts" / "vespa",
    "sample-apps": REPO / "git-checkouts" / "sample-apps",
    "documentation": REPO / "git-checkouts" / "documentation",
}

SKIP_DIRS = {
    ".git", ".gradle", ".idea", ".metals", ".cache", ".venv", "venv",
    "__pycache__", ".mypy_cache", ".pytest_cache", "node_modules",
    "CMakeFiles", "cmake-build-debug", "cmake-build-release", "target",
    "build", "dist", "out", "graphify-out", "_site", "site-packages",
    "vendor",
}

CODE_EXT = {
    ".java", ".cpp", ".cc", ".cxx", ".c", ".h", ".hpp", ".hh",
    ".py", ".sd", ".profile", ".def", ".xml", ".md",
}

DOC_EXT = {".md", ".html", ".htm"}

LANG = {
    ".java": "java",
    ".cpp": "cpp", ".cc": "cpp", ".cxx": "cpp", ".h": "cpp", ".hpp": "cpp", ".hh": "cpp",
    ".c": "c",
    ".py": "python",
    ".sd": "sd", ".profile": "sd",
    ".def": "def",
    ".xml": "xml",
    ".md": "markdown",
    ".html": "html", ".htm": "html",
}

MAX_BYTES = 1_000_000


def keep(repo, rel, size):
    if size <= 0 or size > MAX_BYTES:
        return False
    ext = os.path.splitext(rel)[1].lower()
    if repo == "documentation":
        return rel.startswith("en/") and ext in DOC_EXT
    return ext in CODE_EXT


def main():
    parser = argparse.ArgumentParser(description="Select files from the three checkouts")
    parser.add_argument("--out", required=True)
    parser.add_argument("--limit", type=int, default=0, help="stop after this many files (0 = all)")
    args = parser.parse_args()

    os.makedirs(os.path.dirname(os.path.abspath(args.out)), exist_ok=True)
    count = 0
    with open(args.out, "w", encoding="utf-8") as out:
        for repo, root in ROOTS.items():
            if not os.path.isdir(root):
                print(f"missing checkout: {root}", file=sys.stderr)
                return 1
            for dirpath, dirnames, filenames in os.walk(root):
                dirnames[:] = [
                    d for d in dirnames
                    if d not in SKIP_DIRS and not d.startswith(".")
                ]
                for name in filenames:
                    if name.startswith("."):
                        continue
                    abs_path = os.path.join(dirpath, name)
                    rel = os.path.relpath(abs_path, root).replace(os.sep, "/")
                    try:
                        size = os.path.getsize(abs_path)
                    except OSError:
                        continue
                    if not keep(repo, rel, size):
                        continue
                    ext = os.path.splitext(rel)[1].lower()
                    record = {
                        "repo": repo,
                        "path": rel,
                        "abs": abs_path,
                        "source_language": LANG.get(ext, "text"),
                        "byte_size": size,
                    }
                    out.write(json.dumps(record, ensure_ascii=False) + "\n")
                    count += 1
                    if args.limit and count >= args.limit:
                        print(f"selected {count} files (limit)", file=sys.stderr)
                        return 0
    print(f"selected {count} files", file=sys.stderr)
    return 0


if __name__ == "__main__":
    sys.exit(main())
