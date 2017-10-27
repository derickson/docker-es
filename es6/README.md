## Elastic 6.0.0-rc2 Docker

Full TLS setup for Elastic and Kibana automated


I still run in Docker Toolbox with Virtual Box on my Mac.  So I have to remember to run


```
docker-machine ssh default
sudo sysctl -w vm.max_map_count=262144
```


This is currently using the RC2 snapshot build so run the following command to grab that

```
./pull-snapshots.sh
```

To Start (first run will do a bunch fo setup, taking a few minutes)

* optionally put your Elastic X-Pack license (even the free one) in this folder
* edit the filename setting of your license file in ```run.sh```
* edit user and password related settings at the top of  ```run.sh```

then run
```
./run.sh
```

Passwords, licenses, certificates will all be generated.  When done I access by going to the following in my browser:

```
https://dockermachine:5601
```


as I have my /etc/hosts file point dockermachine to the dockerhost


Tear down the environment with ```./stop-and-clear.sh``` !!! will delete all data and certs !!!
and stop the containers temporarily with ```./down.sh```