# Enable multi-arch build
There are 3 things to configure:
- install multi-arch binary support
- enable docker buildx (buildkit) builds
- dns resolution when doing the build from outside company vpn

## Install multi-arch support
### A simple way
You simply need to run (if you haven't installed qemu-user-static in a different way):
```shell
$ docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
```

This is explained here: https://github.com/multiarch/qemu-user-static#usage

### Preferably
On **Arch Linux** you may install `qemu-user-static-bin` from **AUR**. 
By doing so, you do not need to run the above command every time you need to run
a multi-arch build.

## Enable docker buildx (buildkit) builds
First step would be to enable experimental features inside `~/.docker/config.json`.
Inside that file you need to add the `experimental` field with value `enabled`.
```json
{
  "experimental": "enabled"
}
```

Also, next step is to configure a new build driver.
```shell
$ docker buildx create --use --name multiplatform
```

In order to see the existing drivers you may run `docker buildx ls` and 
`docker buildx use <name>` to switch to a different one.

## Dns resolution
[Here](dns%20resolution%20for%20docker%20and%20buildx.md) you may find the necessary info.

## Docker in docker mode
In order to start a `dind` node run:

`docker run -d --platform linux/amd64 --rm --privileged --name dind -e DOCKER_TLS_CERTDIR= -p 2375-2376:2375-2376 docker:dind`

Arm variant fails with error `level=error msg="failure getting variant" error="getCPUInfo for pattern: Cpu architecture: not found"`.
`docker run -d --platform linux/arm64 --rm --privileged --name dind -e DOCKER_TLS_CERTDIR= -p 2375:2375 -p 2376:2376 docker:dind`.
Basically `containerd` fails.

In order to add a builder instance with a remote node to buildx run:

- `docker buildx create --name remote  tcp://127.0.0.1:2375`
- `docker buildx use remote`

In order to create a context for a remote docker instance run:
- `docker context create remoteX --docker tcp://127.0.0.1:2375`
- `docker context use remoteX`
- `docker buildx use remoteX`


## Usefull environment variables
```properties
BUILDKIT_PROGRESS=plain
DOCKER_BUILDKIT=1
```