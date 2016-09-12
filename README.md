storm-docker
============

Dockerfiles for building a storm cluster. Inspired by [https://github.com/ptgoetz/storm-vagrant](https://github.com/ptgoetz/storm-vagrant)

The images are available directly from [https://index.docker.io](https://index.docker.io)

##Pre-Requisites

- install docker-compose [http://docs.docker.com/compose/install/](http://docs.docker.com/compose/install/)

Quick steps for Ubuntu:

    $ sudo apt-get update
    $ sudo apt-get install apt-transport-https ca-certificates
    $ sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
    $ echo "deb https://apt.dockerproject.org/repo ubuntu-wily main" | sudo tee -a /etc/apt/sources.list.d/docker.list
    $ sudo apt-get update
    $ sudo apt-get purge lxc-docker
    $ sudo apt-get install linux-image-extra-$(uname -r) linux-image-extra-virtual
    $ sudo apt-get install docker-engine
    $ sudo service docker start
    $ sudo docker run hello-world
    $ sudo curl -L https://github.com/docker/compose/releases/download/1.8.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
    $ sudo chmod +x /usr/local/bin/docker-compose

Or:

    $ sudo apt install docker.io
    $ sudo apt install docker-compose
    $ sudo gpasswd -a ${USER} docker
    $ newgrp docker
    $ sudo service docker restart

##Usage

Start a cluster:

- ```docker-compose up```

Destroy a cluster:

- ```docker-compose stop```

Add more supervisors:

- ```docker-compose scale supervisor=3```

Run each container without docker-compose:

- ```docker run -d -p 2181:2181 -p 22 wurstmeister/zookeeper```
- ```docker run -d -p 3773:3773 -p 3772:3772 -p 6627:6627 -p 22 -e ZK_PORT_2181_TCP_ADDR=10.2.0.4 devartis/storm-nimbus:1.0.2```
- ```docker run -d -p 8080:8080 -p 22 -e ZK_PORT_2181_TCP_ADDR=10.2.0.4 -e NIMBUS_PORT_6627_TCP_ADDR=10.2.0.4  devartis/storm-ui:1.0.2```
- ```docker run -d -p 8000:8000 -p 22 -e ZK_PORT_2181_TCP_ADDR=10.2.0.4 -e NIMBUS_PORT_6627_TCP_ADDR=10.2.0.4  devartis/storm-supervisor:1.0.2```

##Building

- ```rebuild.sh```


##FAQ
### How can I access Storm UI from my host?
Take a look at docker-compose.yml:

    ui:
      image: wurstmeister/storm-ui:0.9.2
	      ports:
	        - "49080:8080"

This tells Docker to expose the Docker UI container's port 8080 as port 49080 on the host<br/>

If you are running docker natively you can use localhost. If you're using boot2docker, then do:

    $ boot2docker ip
    The VM's Host only interface IP address is: 192.168.59.103

Which returns your docker VM's IP.<br/>
So, to open storm UI, type the following in your browser:

    localhost:49080

or

    192.168.59.103:49080

in my case.

### How can I deploy a topology?
Since the nimbus host and port are not default, you need to specify where the nimbus host is, and what is the nimbus port number.<br/>
Following the example above, after discovering the nimbus host IP (could be localhost, could be our docker VM ip as in the case of boot2docker), run the following command:

    storm jar target/your-topology-fat-jar.jar com.your.package.AndTopology topology-name -c nimbus.host=192.168.59.103 -c nimbus.thrift.port=49627

### How can I connect to one of the containers?
Find the forwarded ssh port for the container you wish to connect to (use `docker-compose ps`)

    $ ssh root@`boot2docker ip` -p $CONTAINER_PORT

The password is 'wurstmeister' (from: https://registry.hub.docker.com/u/wurstmeister/base/dockerfile/).
