#!/bin/sh

#############################
### Settings
#############################
ES_VERSION="6.0.0-rc1"

USERNAME="myusername"
USERPWD="mypassword"
USEREMAIL="myemail@mydomain.com"
USERFULL="Full Name"


LICENSE_FILE="elastic-internal-non_production.json"



CWD="$PWD"
ES_DIR="/usr/share/elasticsearch"


#############################
### First time Setup
#############################
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

	docker-compose -f docker-compose-startup.yml up -d

	echo "Waiting 20s for Elastic to startup, setup-passwords only works on a running ES ..."
	sleep 20s

	docker exec elasticsearch1 bin/x-pack/setup-passwords auto --batch > passwords.txt

	elasticpwd=$(grep -rhi 'PASSWORD elastic = ' passwords.txt | sed 's/PASSWORD elastic = //g')
	kibanapwd=$(grep -rhi 'PASSWORD kibana = ' passwords.txt | sed 's/PASSWORD kibana = //g')
	logstashpwd=$(grep -rhi 'PASSWORD logstash_system = ' passwords.txt | sed 's/PASSWORD logstash_system = //g')

	echo "ELASTIC_PWD=$elasticpwd" >> .env
	echo "KIBANA_PWD=$kibanapwd" >> .env
	echo "LOGSTASH_PWD=$logstashpwd" >> .env
	rm passwords.txt
	echo "passwords for built in users have been generated, can be found in .env file"


	#############################
	### Attempting license setup if license file exists
	#############################
	if [ -f $LICENSE_FILE ]; then
		echo "applying license"
		curl -XPUT  -u "elastic:$elasticpwd" 'http://dockermachine:9200/_xpack/license' -H "Content-Type: application/json" -d @$LICENSE_FILE
	fi


	#############################
	### Installing named user
	#############################
	echo "creating starting named admin user"
	echo '{
	  "password" : "'$USERPWD'",
	  "full_name" : "'$USERFULL'",
	  "email" : "'$USEREMAIL'",
	  "roles" : [ "superuser" ]
	}' > user.json
	curl -XPOST -u "elastic:$elasticpwd" "http://dockermachine:9200/_xpack/security/user/$USERNAME" -H "Content-Type: application/json" -d @user.json
	rm user.json


	#############################
	### Shutting down first time run (as the ES instance is not started securely)
	#############################
	docker-compose -f docker-compose-startup.yml down

fi

#############################
### Actual startup using secured ES and Kibana
#############################

echo "Starting Environment"
docker-compose up -d

