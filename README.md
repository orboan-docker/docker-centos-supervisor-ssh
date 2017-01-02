# CentOS-7 with supervisord launcher and SSH server | Docker

This is a CentOS-7 Docker with supervisor and SSH server. It is inspired by [million12/centos-supervisor](https://registry.hub.docker.com/u/million12/centos-supervisor/). This image is perfect in case when you need to launch more then one process inside a container and want access via SSH. This image is based on official [centos:centos7](https://registry.hub.docker.com/_/centos/).

## SSH default login 
#### Credentials using username and password:
username: www

password: iaw

You can change them using USER and PASSWORD environment variables. Example:

#### docker run -d -p 2222:22 -p 9001:9001 -e USER=myusername -e PASSWORD=mypassword orboan/docker-centos-supervisor-ssh

## Supervisor management via web interface

Web server is listening in port 9001, thus you may create a new container by running the image adding the option
-p xxxx:9001 to 'docker run' (see example above)

#### Default credentials also are:
username: www

password: iaw

## What's included

##### - bootstrap.sh script

The container has an **ENTRYPOINT** set to `/config/bootstrap.sh`. It iterates through all `/config/init/*.sh` scripts and runs them, then launches supervisord. See [bootstrap.sh](container-files/config/bootstrap.sh) for details.

By default, the **CMD** option in Dockerfile is empty, but the bootstrap.sh script is configured to run everything which is passed into it. Therefore you can launch it in several ways:
* detached mode, no argument(s) passed: supervisord starts in foreground mode and stays until container is stopped.
* detached mode, some argument(s) passed: arguments are executed; supervisord starts in foreground mode and stays until container is stopped.
* interactive mode with TTY (-it), no argument(s) passed: supervisord starts in background mode; interactive bash waits for user input. Exiting from bash (CMD+D) exists the container.
* interactive mode with TTY (-it), some argument(s) passed: supervisord starts in background mode, passed command is executed; container exits.

##### - supervisord

Supervisord is installed and loads services to run from `/etc/supervisor.d/` directory. Add your own files there to launch your services. For example in your `Dockerfile` you could put:  
```ADD my-supervisord-service.conf /etc/supervisord.d/my-supervisord-service.conf```

Learn more about about [supervisord inside containers on official Docker documentation](https://docs.docker.com/articles/using_supervisord/).

##### - init scripts

You can add your .sh scripts to `/config/init` directory to have them executed when container starts. The bootstrap script is configured to run them just before supervisord starts. See [million12/nginx](https://github.com/million12/docker-nginx) for example usage.

##### - error logging

Logfile for supervisord is switched off to avoid logging inside container. Instead, all logs are easily available via `docker logs [container name]`.

This is probably the best approach if you would like to source your logs from outside the container via `docker logs` (also via CoreOS `journald') and you do not want to worry about logging and log management inside your container and/or data volume.

##### - /data volume

The `/data` directory is meant to be used to simply and easily deploy web applications using a volume binding on `/data`, presumably using [data only containers](https://docs.docker.com/userguide/dockervolumes/) pattern.

Recommended structure:  
```
/data/run/ # pid, sockets
/data/conf/ # extra configs for your services
/data/logs/ # logs
/data/www/ # your web application data
```

####  SSH server
##### Default login (username / password):
username: www

password: iaw

You can change them using USER and PASSWORD environment variables.

## Usage

As explained above, this container is configured to run your service(s) both in interactive and non-interactive modes.
  
`docker run -it orboan/centos-supervisor-ssh`: runs supervisord, then interactive bash shell and waits for user's input. Exiting from the shell kills the container.

`docker run -it orboan/centos-supervisor-ssh ps aux`:  runs supervisord, then `ps aux` command inside container and exists.

`docker run -it orboan/centos-supervisor-ssh top`:  runs supervisord, then `top` tool. Exiting from top exits the container.

`docker run -d orboan/centos-supervisor-ssh`: detached, runs supervisord in foreground mode and its configured services (ssh daemon and others you may add)

`docker run -d orboan/centos-supervisor touch 'test-file'`: detached, runs `touch 'test-file'` command, then supervisord in foreground mode and its configured services


## Build

`docker build --tag=orboan/centos-supervisor-ssh .`


## Author

Author: Oriol Boix Anfosso (<dev@orboan.com>)

Work forked from [million12/centos-supervisor], so thanks to its authors:

Author: Marcin Ryzycki (<marcin@m12.io>)  
Author: Przemyslaw Ozgo (<linux@ozgo.info>)  
This work is also inspired by [maxexcloo](https://github.com/maxexcloo)'s work on his [docker images](https://github.com/maxexcloo/Docker). Many thanks.
