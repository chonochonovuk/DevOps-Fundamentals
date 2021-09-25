FROM openjdk:8

# Taken from https://github.com/aboullaite/docker-elk

ENV DEBIAN_FRONTEND noninteractive

ENV ELASTICSEARCH_VERSION 7.14.0
# Add esuser to avoid starting Elasticsearch as the root user.
RUN useradd -d /home/esuser -m esuser
WORKDIR /home/esuser

RUN mkdir /data

# Install Elastisearch
RUN \
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ELASTICSEARCH_VERSION}-linux-x86_64.tar.gz && \
tar xvzf elasticsearch-${ELASTICSEARCH_VERSION}-linux-x86_64.tar.gz && \
rm -f elasticsearch-${ELASTICSEARCH_VERSION}-linux-x86_64.tar.gz && \
chown -R esuser:esuser elasticsearch-${ELASTICSEARCH_VERSION}

# elasticsearch.yml and Dockerfile are on same location
ADD elasticsearch.yml /home/esuser/elasticsearch-${ELASTICSEARCH_VERSION}/config/elasticsearch.yml
ENTRYPOINT elasticsearch-${ELASTICSEARCH_VERSION}/bin/elasticsearch
