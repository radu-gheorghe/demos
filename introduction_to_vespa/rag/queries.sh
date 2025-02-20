# traceLevel=1 will show the prompt and some stats
vespa query \
    --header="X-LLM-API-KEY:YOUR_OPENAI_KEY_GOES_HERE" \
    query="what kind of mini stencils do you have for sale?" \
    query_text="Mini Stencil" \
    yql="select * from product where title contains @query_text OR ({targetHits:100}nearestNeighbor(titledesc_embedding,query_embedding))" \
    'input.query(query_embedding)'="embed(@query_text)" \
    ranking.profile="closeness" \
    presentation.summary="titledesc" \
    hits=20 \
    searchChain=openai \
    format=sse \
    traceLevel=0
