FROM ubirch/java
MAINTAINER falko.zurell@ubirch.com
# Export HTTP & Transport
EXPOSE 9200 9300

ENV VERSION 2.4.2
WORKDIR /
# Install Elasticsearch.
RUN apt-get update && apt-get install bash curl ca-certificates sudo -y && \
  ( curl -Lskj https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/$VERSION/elasticsearch-$VERSION.tar.gz | \
  gunzip -c - | tar xf - ) && \
  mv /elasticsearch-$VERSION /elasticsearch && \
  rm -rf $(find /elasticsearch | egrep "(\.(exe|bat)$)") && \
  apt-get purge curl -y

# Volume for Elasticsearch data
VOLUME ["/data"]

# Copy run script
COPY run.sh /
# Override config, otherwise plug-in install will fail
ADD config /elasticsearch/config
# Set environment variables defaults
ENV ES_JAVA_OPTS "-Xms512m -Xmx512m"
ENV CLUSTER_NAME elasticsearch-default
ENV NODE_MASTER true
ENV NODE_DATA true
ENV NODE_INGEST true
ENV HTTP_ENABLE true
ENV NETWORK_HOST _site_
ENV HTTP_CORS_ENABLE true
ENV HTTP_CORS_ALLOW_ORIGIN *
ENV NUMBER_OF_MASTERS 1
ENV NUMBER_OF_SHARDS 1
ENV NUMBER_OF_REPLICAS 0
ENV MAX_LOCAL_STORAGE_NODES 1




# Set environment
ENV NAMESPACE default
ENV DISCOVERY_SERVICE elasticsearch-discovery


CMD ["/run.sh"]
