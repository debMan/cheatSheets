# docker: A simple personal cheatsheet

_**Note:**_ This document is not completed.  
This is my personal **Docker**  cheatsheet.

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
docker container run -d --rm --name nginx -p 8080:80 -v /var/ww/html:/usr/share/nginx/html nginx:latest
docker container run -it --name ubuntu --net host ubuntu:bionic [OPTIONAL_CMD]
docker container run -d --name db -e MYSQL_RANDOM_ROOT_PASSWORD=true mysql 
# OPTIONAL_CMD can be used to replace image's default startup command with CMD 
# -d, --detach: as a daemon, -it: interactive TTY after start into container, 
# --rm: removes container after stop, -v: mount local_path:container_path
# -p, --publish: expose local:container ports, --name: name container
# -e, --env: pass enviroment variable to the container, 
# --net host: skip virtual networks and use host IP, you can change host with
# special network which is available with `docker network ls`
docker container exec -it ID     # run additional command in an existing cnt.
docker container start -ai ID    # attach STDOUT/STDERR and forward signals 
docker container attach ID      
docker container logs ID         # logs of a container
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

``` bash
docker network ls
# the default network structure for clean instal is:
# NETWORK ID          NAME                DRIVER              SCOPE
# 4be045378e0f        bridge              bridge              local
# cf2891e38604        host                host                local
# 6c99c404fe98        none                null                local
docker network inspect ID 
docker network --driver bridge create my_network
# REMEMBER: on docker run use  --net=host to skip virtual network & use host IP
docker network connect NETWORK CONTAINER
docker network disconnect NETWORK CONTAINER

```
#### More info about network

* [docker network docs](https://docs.docker.com/network/)
* [Docker network driver plugins](https://docs.docker.com/v17.09/engine/extend/plugins_network/)
* [Work with network commands](https://docs.docker.com/v17.09/engine/userguide/networking/work-with-networks/)
* [Understanding Docker Networking Drivers and their use cases](https://www.docker.com/blog/understanding-docker-networking-drivers-use-cases/)

## Dockerfile

This is an example of a `Dockerfile`:

``` Dockerfile
FROM ubuntu:bionic
MAINTAINER idebman <idebman@gmail.com>

RUN apt-get update -y && apt-get upgrade -y \ 
&& apt-get install -y git apache2 locales libass-dev libpq-dev postgresql \
build-essential redis-server redis-tools python3-pip \
&& pip3 install -U pip virtualenv && rm -rf /var/lib/apt/lists/* \
&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8
ENV HOSTNAME example.com
EXPOSE 80
CMD /usr/sbin/apache2ctl -D FOREFROUND
```

Then, to build this docker image:
``` bash
docker image build  -t idebman/reApache  .
# the dot ( . ) referes to the Dockerfile location.
```
## Next steps

* Dockerfile
* volumes
* ports
* network
* build, tag, push
* swarm
* docker-compose
* docker-machine

