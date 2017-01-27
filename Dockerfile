FROM quay.io/pires/docker-elasticsearch:2.4.1

MAINTAINER falko.zurell@ubirch.com

# Override config, otherwise plug-in install will fail
ADD config /elasticsearch/config

# Set environment
ENV NAMESPACE default
ENV DISCOVERY_SERVICE elasticsearch-discovery
