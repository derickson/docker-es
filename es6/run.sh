# #!/bin/sh

ES_VERSION="6.0.0-rc1"
CWD="$PWD"
ES_DIR="/usr/share/elasticsearch"


ENV_FILE_NAME=".env"
if [ -f $ENV_FILE_NAME ]; then
	echo "The .env file '$FILE' exists. Skipping Password Setup"
else
	echo "The .env file does not exist. "
	
	#############################
	echo "Creating certificates for production running with TLS"
	#############################

	rm -rf certificates
	mkdir -p certificates
	cp instances.yml certificates/.

	docker run -it --rm \
	    -v "$CWD/certificates:$ES_DIR/config/x-pack/certificates" \
	    -w $ES_DIR \
	    "docker.elastic.co/elasticsearch/elasticsearch:$ES_VERSION" \
	    bin/x-pack/certgen --silent \
	    	--in $ES_DIR/config/x-pack/certificates/instances.yml \
	    	--out $ES_DIR/config/x-pack/certificates/bundle.zip

	unzip -o certificates/bundle.zip -d certificates
	rm certificates/bundle.zip
	openssl x509 -in certificates/ca/ca.crt  -out certificates/ca/ca.pem -outform PEM
	echo "Done creating certificates"

	#############################
	echo "Starting password setup"
	#############################

	# docker run --rm -d --name elasticsearch1 \
	# 	-v "$CWD/data/es_s1:$ES_DIR/data" \
	# 	-p "9200:9200" \
	# 	"docker.elastic.co/elasticsearch/elasticsearch:$ES_VERSION"
	docker-compose -f docker-compose-startup.yml up -d

	echo "Waiting 30s for Elastic to startup ..."
	sleep 30s

	docker exec elasticsearch1 bin/x-pack/setup-passwords auto --batch > passwords.txt


	elasticpwd=$(grep -rhi 'PASSWORD elastic = ' passwords.txt | sed 's/PASSWORD elastic = //g')
	kibanapwd=$(grep -rhi 'PASSWORD kibana = ' passwords.txt | sed 's/PASSWORD kibana = //g')
	logstashpwd=$(grep -rhi 'PASSWORD logstash_system = ' passwords.txt | sed 's/PASSWORD logstash_system = //g')

	# echo $elasticpwd
	# echo $kibanapwd
	# echo $logstashpwd

	echo "ELASTIC_PWD=$elasticpwd" >> .env
	echo "KIBANA_PWD=$kibanapwd" >> .env
	echo "LOGSTASH_PWD=$logstashpwd" >> .env
	rm passwords.txt


	LICENSE_FILE="elastic-internal-non_production.json"
	if [ -f $LICENSE_FILE ]; then
		echo "applying license"
		curl -XPUT  -u "elastic:$elasticpwd" 'http://dockermachine:9200/_xpack/license' -H "Content-Type: application/json" -d @$LICENSE_FILE
	fi

	docker-compose -f docker-compose-startup.yml down

fi

echo "Starting Environment"
docker-compose up -d


# curl -XGET -u elastic -H "Content-Type: application/json" http://client:9200
# curl -XGET -H "Content-Type: application/json" http://dockermachine:9200
# curl -XGET -k -u "elastic" -H "Content-Type: application/json" https://elasticsearch1:9200
# curl -XGET --cacert config/certificates/ca/ca.pem -u "kibana" -H "Content-Type: application/json" https://elasticsearch1:9200
# curl -XGET -u "kibana" -H "Content-Type: application/json" http://elasticsearch1:9200
# QsRW?G&Izw9fB$8lwGyF
# cat /proc/1/environ
