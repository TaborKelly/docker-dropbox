# docker-dropbox
## Introduction
A container for [Dropbox](https://www.dropbox.com/). Based on work by [cturra](https://github.com/cturra/docker-dropbox) and [janeczku](https://github.com/janeczku/docker-dropbox). Image based on Ubuntu 18.04.

## Building
This will build an image named `docker-dropbox`:
```
./build.sh
```

## Running
### On the host
First, create a user and group for `dropbox` and add yourself to the `dropbox` group. Hopefully, UID/GID 500 is free on your system. If not you can pick a different number and modify the UID/GID in the Dockerfile.
```
$ sudo groupadd -g 500 dropbox
$ sudo useradd -M -s /sbin/nologin -u 500 -g 500 dropbox
$ sudo usermod -a -G dropbox $USER
```

**Don't forget to logout and back it to get your new `dropbox` group permissions.**

Now, create a directory that is owned by the `dropbox` user/group:
```
sudo mkdir /some/path/for/dropbox
sudo chown dropbox:dropbox /some/path/for/dropbox
```

### Running the container
This will start the the image, name the container `dropbox`, and limit it to 512MB or RAM.
```
./run.sh /some/path/for/dropbox
```

Next, check the logs to link the computer with your dropbox account.
```
$ docker logs dropbox
...
2019-02-17 03:44:55,186 DEBG 'dropbox' stdout output:
This computer isn't linked to any Dropbox account...
2019-02-17 03:44:55,186 DEBG 'dropbox' stdout output:


2019-02-17 03:44:55,431 DEBG 'dropbox' stdout output:
Please visit https://www.dropbox.com/cli_link_nonce?nonce=SOMELONGNONCE to link this device.
```

### Fixing file permissions
The docker container is configured to create most files readable and writable by anyone in the `dropbox` group. However, Dropbox sets more restrictive permissions for the directory that it syncs into, so just once you will need to fix them:
```
sudo chmod g+rw /some/path/to/dropbox/Dropbox
```

### Poking around the container
If for some reason you need to poke around the container you can do that the normal Docker way:
```
docker exec -it dropbox /bin/bash
```

### Further reading
https://www.dropbox.com/install-linux
