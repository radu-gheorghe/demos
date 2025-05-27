podman rm -v vespa-vector-search

podman run --name vespa-custom-components --hostname vespa-custom-components \
  --publish 8080:8080 --publish 19071:19071 \
  vespaengine/vespa 

# clone the app
cd 6.custom_components
vespa clone album-recommendation-java album-recommendation-java

cd album-recommendation-java

# explore pom.xml --> note the artifactId that is used in services.xml as bundle name

mvn -U package

# explore schema (album field), then services.xml (custom chain) and MetalSearcher.java (adds the metal OR clause when artist contains metal names)

vespa deploy

# feed the sample data
vespa feed src/test/resources/*.json

# feed the unknown artist album that contains the word "metal"
vespa feed ../unknown-album.json

# normal query (the "default" search chain) - only returns the Metallica album
vespa query yql="select * from music where artist contains 'metallica'"

# search chain that uses MetalSearcher should return the unknown artist album as well
# because we inject the album:metal OR clause in the query
vespa query yql="select * from music where artist contains 'metallica'" searchChain=metalchain