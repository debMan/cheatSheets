# docker: A simple personal cheatsheet

_**Note:**_ This document is not completed.  
This is my personal **Docker**  cheatsheet.

Before starting, please check the 
[Docker overview](https://docs.docker.com/get-started/overview/).

## Best way to setup

This is best practice to install stable release, not edge version.
_**NOTE:**_ Do not use default `apt` or `yum` repos. They have out-of-date
version.

``` bash
curl -sSL https://get.docker.com/ | sh
# to run docker command without sudo prefix:
sudo usermod -aG docker $(whoami)
```

Also, install [`docker-compose`](https://github.com/docker/compose/releases) 
and [`docker-machine`](https://github.com/docker/machine/releases) from github 
releases page.

## Overview

The **new docker** usage is something like this:

```
docker version
docker info

docker [OPTIONS] MANAGEMENT_COMMANDS SUB_COMMAND 
docker COMMAND --help

which:
Options:
      --config string      Location of client config files (default "/home/debman/.docker")
  -c, --context string     Name of the context to use to connect to the daemon (overrides DOCKER_HOST env var and default context set with
                           "docker context use")
  -D, --debug              Enable debug mode
  -H, --host list          Daemon socket(s) to connect to
  -l, --log-level string   Set the logging level ("debug"|"info"|"warn"|"error"|"fatal") (default "info")
      --tls                Use TLS; implied by --tlsverify
      --tlscacert string   Trust certs signed only by this CA (default "/home/debman/.docker/ca.pem")
      --tlscert string     Path to TLS certificate file (default "/home/debman/.docker/cert.pem")
      --tlskey string      Path to TLS key file (default "/home/debman/.docker/key.pem")
      --tlsverify          Use TLS and verify the remote
  -v, --version            Print version information and quit

Management Commands:
  builder     Manage builds
  config      Manage Docker configs
  container   Manage containers
  context     Manage contexts
  engine      Manage the docker engine
  image       Manage images
  network     Manage networks
  node        Manage Swarm nodes
  plugin      Manage plugins
  secret      Manage Docker secrets
  service     Manage services
  stack       Manage Docker stacks
  swarm       Manage Swarm
  system      Manage Docker
  trust       Manage trust on Docker images
  volume      Manage volumes
```

and the **old** usage is like: 

```
docker [OPTION] COMMAND

which:
  attach      Attach local standard input, output, and error streams to a running container
  build       Build an image from a Dockerfile
  commit      Create a new image from a container's changes
  cp          Copy files/folders between a container and the local filesystem
  create      Create a new container
  diff        Inspect changes to files or directories on a container's filesystem
  events      Get real time events from the server
  exec        Run a command in a running container
  export      Export a container's filesystem as a tar archive
  history     Show the history of an image
  images      List images
  import      Import the contents from a tarball to create a filesystem image
  info        Display system-wide information
  inspect     Return low-level information on Docker objects
  kill        Kill one or more running containers
  load        Load an image from a tar archive or STDIN
  login       Log in to a Docker registry
  logout      Log out from a Docker registry
  logs        Fetch the logs of a container
  pause       Pause all processes within one or more containers
  port        List port mappings or a specific mapping for the container
  ps          List containers
  pull        Pull an image or a repository from a registry
  push        Push an image or a repository to a registry
  rename      Rename a container
  restart     Restart one or more containers
  rm          Remove one or more containers
  rmi         Remove one or more images
  run         Run a command in a new container
  save        Save one or more images to a tar archive (streamed to STDOUT by default)
  search      Search the Docker Hub for images
  start       Start one or more stopped containers
  stats       Display a live stream of container(s) resource usage statistics
  stop        Stop one or more running containers
  tag         Create a tag TARGET_IMAGE that refers to SOURCE_IMAGE
  top         Display the running processes of a container
  unpause     Unpause all processes within one or more containers
  update      Update configuration of one or more containers
  version     Show the Docker version information
  wait        Block until one or more containers stop, then print their exit codes
```

## Basic commands

``` bash
# Anywhere, we can use container name instead of container ID to select a container.
docker container run -d --rm --name nginx \
  -p 8080:80 -v /var/ww/html:/usr/share/nginx/html \
  nginx:latest
docker container run -it --name ubuntu --net host ubuntu:bionic [OPTIONAL_CMD]
docker container run -d --name db -e MYSQL_RANDOM_ROOT_PASSWORD=true mysql 
docker container run -d --network-alias db --net my_bridge mysql
# OPTIONAL_CMD can be used to replace image's default startup command with CMD 
# -d, --detach: as a daemon, -it: interactive TTY after start into container, 
# --rm: removes container after stop, -v: mount local_path:container_path
# -p, --publish: expose host:container ports, --name: name container
# -e, --env: pass enviroment variable to the container, 
# --net host: skip virtual networks and use host IP, you can change host with
# special network which is available with `docker network ls`
# --network-alias, --net-alias: adds an alias to be resolved in same network.
# mulitple containers can be assigned as same alias for load balancing purposes

docker container exec -it ID CMD # run additional command in an existing cnt.
docker container start -ai ID    # attach STDOUT/STDERR and forward signals 
docker container attach ID      
docker container logs ID         # logs of a container
# use -f to follow logs as the container runs
docker container top ID          # process list in a container
docker container inspect         # details of a container
docker container stats           # stats for all or a single container
docker container ls -a           # -a includes stopped ones. 
docker container stop ID         # accepts multiple IDs
docker container rm ID           # acepts multiple IDs 
docker container rm $(docker container ls -qa) # -q: just print ID
docker container port  ID        # check ports for a container
```

## Networking

* Each container connected to a private virtual network `bridge`
* Each virtual network routes through NAT firewall on host IP
* All containers on a virtual network can talk to each other without `-p`
* Best practice is to create a new virtual network for each app:
  - network `my_web_app` for mysql and php/apache containers
  - network `my_api` for mongo and nodejs containers
* Multiple containers can be attached to a same network.
* More new virtual networks can be created.
* Docker uses the container names as their host name for containers talking to
  each other on new bridge networks which created. (NOT default bridge). It can
  be reached with `--link` on default network when using `docker run` but hard.
``` bash
docker network ls
# the default network structure for clean instal is:
# NETWORK ID          NAME                DRIVER              SCOPE
# 4be045378e0f        bridge              bridge              local
# cf2891e38604        host                host                local
# 6c99c404fe98        none                null                local
docker network inspect ID 
docker network --driver bridge create my_network
# RECOMENDED: because DNS resolution achieved on new bridge network.
# REMEMBER: on docker run use  --net=host to skip virtual network & use host IP
docker network connect NETWORK CONTAINER
docker network disconnect NETWORK CONTAINER
# RECOMENDED: use a --network-alias for DNS resolution
```
#### More info about network

* [docker network docs](https://docs.docker.com/network/)
* [Docker network driver plugins](https://docs.docker.com/v17.09/engine/extend/plugins_network/)
* [Work with network commands](https://docs.docker.com/v17.09/engine/userguide/networking/work-with-networks/)
* [Understanding Docker Networking Drivers and their use cases](https://www.docker.com/blog/understanding-docker-networking-drivers-use-cases/)

## Images

A good article about image is [Docker Image Specification](https://github.com/moby/moby/blob/master/image/spec/v1.md).  
Another article about [Storage drivers](https://docs.docker.com/storage/storagedriver/).  

Multi tags can be assigned to the same image ID which means no overhead added
to tags. 

``` bash
docker image ls 
docker image history nginx
docker image inspect nginx
docker image tage ANY_IMAGE[:ANY_TAG] USERNAME/MY_MAGE[:MY_TAG]
docker login
# it stores credentionals at ~/.docker/config.json
docker image push USERNAME/my-nginx[:test_tag] 
docker logout
```

## Dockerfile

The `Dockerfile` is actually a recipe for creating your image.

### Examples

A simpleDockerfile:

``` Dockerfile
FROM ubuntu:bionic
MAINTAINER idebman <idebman@gmail.com>

RUN apt-get update -y && apt-get upgrade -y \ 
&& apt-get install -y git apache2 locales libass-dev libpq-dev postgresql \
build-essential redis-server redis-tools python3-pip nginx\
&& pip3 install -U pip virtualenv && rm -rf /var/lib/apt/lists/* \
&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8
ENV HOSTNAME example.com
EXPOSE 80
CMD /usr/sbin/apache2ctl -D FOREFROUND
```

Or my prefared workspace is:

``` Dockerfile
FROM ubuntu:bionic
MAINTAINER carrene <info@carrene.com>
COPY .ssh /root/.ssh
# place .ssh contains private and public key for default carrene user
# and known-hosts with git server host keys beside Dockerfile in the same dir
# to be copied inside docker image
ENV TZ=Asia/Tehran DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y \
  && ln -sf /usr/share/zoneinfo/$TZ /etc/localtime \
  && apt-get install -y apt-utils locales tzdata \
  && locale-gen en_US.UTF-8 \
  && update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 LANGUAGE=en_US.UTF-8 \
  && apt-get install -y apt-utils libass-dev libpq-dev postgresql \
  build-essential curl redis-server redis-tools python3-pip python3-dev git \
  && pip3 install -U pip setuptools wheel virtualenv \
  && apt-get autoremove -y && apt-get upgrade -y && chmod 755 /root/.ssh \
  && chmod 644 /root/.ssh/* && chmod 600 /root/.ssh/id_rsa \ 
  && rm -rf /var/lib/apt/lists/* && service postgresql start \
  && su postgres -c \
  "psql -U postgres -c \"ALTER USER postgres PASSWORD 'postgres';\"" \
  && echo "listen_addresses='*'" >> /etc/postgresql/10/main/postgresql.conf \
  && echo "bind 127.0.0.1" >> /etc/redis/redis.conf
CMD service postgresql start && service redis-server start && /bin/bash
```

Default `nginx`'s Dockerfile:

``` Dockerfile
# NOTE: this example is taken from the default Dockerfile for the official nginx Docker Hub Repo
# https://hub.docker.com/_/nginx/
# NOTE: This file is slightly different than the video, because nginx versions have been updated
#       to match the latest standards from docker hub... but it's doing the same thing as the video
#       describes
FROM debian:stretch-slim
# all images must have a FROM
# usually from a minimal Linux distribution like debian or (even better) alpine
# if you truly want to start with an empty container, use FROM scratch

ENV NGINX_VERSION 1.13.6-1~stretch
ENV NJS_VERSION   1.13.6.0.1.14-1~stretch
# optional environment variable that's used in later lines and set as envvar when container is running

RUN apt-get update \
	&& apt-get install --no-install-recommends --no-install-suggests -y gnupg1 \
	&& \
	NGINX_GPGKEY=573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62; \
	found=''; \
	for server in \
		ha.pool.sks-keyservers.net \
		hkp://keyserver.ubuntu.com:80 \
		hkp://p80.pool.sks-keyservers.net:80 \
		pgp.mit.edu \
	; do \
		echo "Fetching GPG key $NGINX_GPGKEY from $server"; \
		apt-key adv --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$NGINX_GPGKEY" && found=yes && break; \
	done; \
	test -z "$found" && echo >&2 "error: failed to fetch GPG key $NGINX_GPGKEY" && exit 1; \
	apt-get remove --purge -y gnupg1 && apt-get -y --purge autoremove && rm -rf /var/lib/apt/lists/* \
	&& echo "deb http://nginx.org/packages/mainline/debian/ stretch nginx" >> /etc/apt/sources.list \
	&& apt-get update \
	&& apt-get install --no-install-recommends --no-install-suggests -y \
						nginx=${NGINX_VERSION} \
						nginx-module-xslt=${NGINX_VERSION} \
						nginx-module-geoip=${NGINX_VERSION} \
						nginx-module-image-filter=${NGINX_VERSION} \
						nginx-module-njs=${NJS_VERSION} \
						gettext-base \
	&& rm -rf /var/lib/apt/lists/*
# optional commands to run at shell inside container at build time
# this one adds package repo for nginx from nginx.org and installs it

RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log
# forward request and error logs to docker log collector

EXPOSE 80 443
# expose these ports on the docker virtual network
# you still need to use -p or -P to open/forward these ports on host

CMD ["nginx", "-g", "daemon off;"]
# required: run this command when container is launched
# only one CMD allowed, so if there are multiple, last one wins
```

In this example, note to the linking `stdin` and `stderr` to the `nginx` logs.

Here is another example which copies `index.html` into docker image:

``` Dockerfile
# this same shows how we can extend/change an existing official image from Docker Hub

FROM nginx:latest
# highly recommend you always pin versions for anything beyond dev/learn

WORKDIR /usr/share/nginx/html
# change working directory to root of nginx webhost
# using WORKDIR is preferred to using 'RUN cd /some/path'

COPY index.html index.html

# I don't have to specify EXPOSE or CMD because they're in my FROM
```
### Some best practices

- [7 best practices for building containers](https://cloudplatform.googleblog.com/2018/07/7-best-practices-for-building-containers.html)
- [Docker for Python Developers](https://mherman.org/presentations/dockercon-2018/#1)
- [Best practices for writing Dockerfiles - Docker docs](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [Docker development best practices - Docker docs](https://docs.docker.com/develop/dev-best-practices/)
- [Manage sensitive data with Docker secrets - Docker docs](https://docs.docker.com/engine/swarm/secrets/)
- [6 Dockerfile Tips from the Official Images](https://blog.container-solutions.com/6-dockerfile-tips-official-images)
- [Docker Reference Architecture: Design Considerations and Best Practices to Modernize Traditional Apps](https://success.docker.com/article/mta-best-practices)
 
### Build the Dockerfile

Then, to build this docker image:

``` bash
docker image build -f Dockerfile -t idebman/reApache .
# The dot (.) referes to where the Docker file is located
```

You can open [Dockerfile reference](https://docs.docker.com/engine/reference/builder/)
for more info.

## Persistent data

We have several options: 
- Volumes
- binding
- `tmpfs`

``` bash
docker volume prune 
docker container run --rm --name psql postgres
# creates default volume in host machine at /var/lib/docker/volumes/<VOLUME_ID>
# also, this volume will be deleted if --rm used, and not deleted if --rm NOT used
# volumes can be specified in Dockerfile
docker container run --rm --name psql -v my-named-volume:/var/lib/postgresql/data postgres
# creates named volume, more user-friendly method to use volumes.
# named volumes does not delete automatically even --rm used.
docker container run --rm --name psql -v /path/to/my/data/on/host:/var/lib/postgresql/data postgres
# creates binding between host and container. mapping of the host
# files/directories into a container. binds start with slash on the left side
# the two locations point to the same files/directories
# bindings can not be specified in Dockerfile, only defined at runtime
# always the host files win and the host files will be used.

docker container inspect CONTAINER_ID/NAME   
# can find mapped mount point ofvolumes to host
docker volume ls
docker volume inspect VOLUME_ID/NAME
docker container inspect CONTAINERID?NAME # Under Mount section find volumes
docker volume rm VOLUME_ID/NAME
docker volume create VOLUME_NAME
```
## Docker system

``` bash
docker system df        # disk usage of docker system
docker system prune     # clears the systems
# or clean special parts
docker image prune
docker container prune
```

## Next steps

* docker-compose
* swarm
* docker-machine

