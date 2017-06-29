![Transmission](http://blogmmix.ch/sites/default/files/imagecache/gross/6/transmission-bittorrent1.png)

[![Build Status](https://drone.xataz.net/api/badges/xataz/docker-transmission/status.svg)](https://drone.xataz.net/xataz/docker-transmission)
[![](https://images.microbadger.com/badges/image/xataz/transmission.svg)](https://microbadger.com/images/xataz/transmission "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/xataz/transmission.svg)](https://microbadger.com/images/xataz/transmission "Get your own version badge on microbadger.com")

> This image is build and push with [drone.io](https://github.com/drone/drone), a circle-ci like self-hosted.
> If you don't trust, you can build yourself.

## Tag available
* latest [(Dockerfile)](https://github.com/xataz/dockerfiles/tree/master/transmission/Dockerfile)

## Description
What is [Transmission](http://www.transmissionbt.com/) ?

Open Source.  
Transmission is an open source, volunteer-based project. Unlike some BitTorrent clients, Transmission doesn't play games with its users to make money:

* Transmission doesn't bundle toolbars, pop-up ads, flash ads, twitter tools, or anything else.
* It doesn't hold some feaures back for a payware version.
* Its source code is available for anyone to review.
* We don't track our users, and our website and forums have no third-party ads or analytics. 

Easy.  
Transmission is designed for easy, powerful use. We've set the defaults to "Just Work" and it only takes a few clicks to configure advanced features like watch directories, bad peer blocklists, and the web interface. When Ubuntu chose Transmission as its default BitTorrent client, one of the most-cited reasons was its easy learning curve.

**This image not contains root process**

## Build Image

```shell
docker build -t xataz/transmission github.com/xataz/dockerfiles.git#master:transmission
```

## Configuration
### Environments
* WEBROOT : Choose webroot of transmission (default : nothing)
* UID : Choose uid for launch transmission (default : 991)
* GID : Choose gid for launch transmission (default : 991)

### Volumes
* /data : Path where is download torrent
* /home/transmission/.config/transmission-daemon/ : Path where is configuration files 

### Ports
* 9091

## Usage
### Speed launch
```shell
docker run -d -p 9091:9091 xataz/transmission
```
URI access : http://XX.XX.XX.XX:9091/web/

### Advanced launch
```shell
docker run -d -p 8080:9091 \
	-e WEBROOT=/tbt \
	-e UID=1001 \
	-e GID=1001 \
	-v /docker/config/tbt:/config \
	xataz/transmission
```
URI access : http://XX.XX.XX.XX:8080/tbt/web/

## Contributing
Any contributions, are very welcome !