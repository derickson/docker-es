#!/bin/sh


docker rmi docker.elastic.co/elasticsearch/elasticsearch:6.2.4
docker pull docker.elastic.co/elasticsearch/elasticsearch:6.2.4

docker rmi docker.elastic.co/kibana/kibana:6.2.4
docker pull docker.elastic.co/kibana/kibana:6.2.4

docker rmi docker.elastic.co/logstash/logstash:6.2.4
docker pull docker.elastic.co/logstash/logstash:6.2.4