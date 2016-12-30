#Dave Docker Elastic Stack


This is my working area for running a complete Elastic stack (Elastisearch, Kibana, Logstash, Filebeat) inside docker.

```
Jekyll <-- Apache2 Proxy 
              |
              V
        Filebeat Sidecar --> Logstash --> ES --> Kibana
```

## Step 1. matching my environment setup

I run Docker on my Macintosh laptop using Docker Toolkit.  I have not swithced over to native MacOS virtualization yet.

* install VirtualBox
* install Docker Toolkit
* Expand the default VM's memory to 8 GB of RAM
* edit the default VM's vm.max_map_count setting 

```
docker-machine ssh default
sudo vi /var/lib/boot2docker/profile
# Add this line into the profile file
sysctl -w vm.max_map_count=262144
```

* reboot the default docker-machine ```docker-machine restart```
* figure out the local ip of the docker machine with ```docker-machine ip default```
* Enter this IP into your local MacOS ```/etc/hosts``` file to map a hostname called ```dockermachine```.  For me this is ```192.168.99.100  dockermachine```.  I do this so that I can have predictable bookmarks for the kibana and example apache servers, etc

* confirm the docker environement works by running the following from the Docker Quickstart Terminal

```docker run hello-world```


## Step 2. prepping the jekyll and docker-compose file

* in a separate folder clone my personal blog (this is the example website being proxied to generate standard apache logs

```> git clone https://github.com/derickson/derickson.github.io.git```

* edit the docker compose file with the following local edits (mostly marked in comments with ```!!!```
	* absolute path to logstash pipeline folder
	* absolute path to jeyll site folder

## Step 3. launching the environement

This will likely have to pull lots of images, etc so be prepared for a big download of linux images, es, kibana etc.

```> docker-compose up -d```

Now you can point your web browser to 

[http://dockermacine/](http://dockermacine/)

to see the web site being proxied.  You can log into kibana with

[http://dockermachine:5601/](http://dockermachine:5601/)

You'll have to create the ```logstash-*``` index pattern

## Step 4. Cleaning everything up

* turn off the environement (will delete containers but not es data)

```docker-compose down```

* remember the ./data folder has your indexes in it, if you want to delete those

