#!/bin/sh


docker rmi docker.elastic.co/elasticsearch/elasticsearch-platinum:6.0.0-rc2-SNAPSHOT 
curl -L snapshots.elastic.co/docker/elasticsearch-platinum-6.0.0-rc2-SNAPSHOT.tar.gz | docker load

docker rmi docker.elastic.co/elasticsearch/kibana:6.0.0-rc2-SNAPSHOT 
curl -L snapshots.elastic.co/docker/kibana-6.0.0-rc2-SNAPSHOT.tar.gz | docker load