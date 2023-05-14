# Enable multi-arch build
There are 3 things to configure:
- enable multi-arch binary support
- enable docker buildx (BuildKit) builds
- dns resolution when doing the build from outside company vpn

## Enable multi-arch support
### Option 1: qemu-user-static 
On **Arch Linux** it is enough to install `qemu-user-static-binfmt`:
```shell
$sudo pacman -S qemu-user-static-binfmt
```

On **Ubuntu** it is enough to install `qemu-user-static`:
```shell
$sudo apt-get install qemu-user-static
```
By doing so, you do not need to run the above command every time you need to run
a multi-arch build.

### Option 2: multiarch/qemu-user-static docker image 
You simply need to run (if you haven't installed qemu-user-static in a different way):
```shell
$docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
```

This is explained here: [qemu user static images usage](https://github.com/multiarch/qemu-user-static#usage).

## Enable docker buildx (BuildKit) builds
**BuildKit is the default builder on linux as of docker 23.0.0.**

Otherwise, follow instructions here:
[BuildKit | Docker Documentation](https://docs.docker.com/build/buildkit/#getting-started)

Alternatively, you may want to create a different BuildKit builder for multiplatform builds 
and switch to it. To do so run:
```shell
$docker buildx create --use --name multiplatform
```

If you are using an older docker version, you may need to enable experimental features docker daemon config
`/etc/docker/daemon.json` by adding the `experimental` flag.
```json
{
  "experimental": true
}
```
And restart docker service using:
```shell
$sudo systemctl restart docker
``` 

In order to see the existing drivers you may run `docker buildx ls` and 
`docker buildx use <name>` to switch to a different one.

## Dns resolution
[Here](dns%20resolution%20for%20docker%20and%20buildx.md) you may find the necessary info.

## Docker in docker mode
In order to start a `dind` node run:

```shell
$docker run -d --rm --privileged --name dind -e DOCKER_TLS_CERTDIR= -p 2375-2376:2375-2376 docker:dind
```

If `qemu-user-static` is installed on the host, `dind` daemon should be able to build multi-arch images.

In order to add a builder instance with a remote node to buildx run:
```shell
$docker buildx create --name dind tcp://127.0.0.1:2375
$docker buildx use dind
```

In order to create a context for a remote docker instance run:
I do not recommend doing this for a local dind instance. Just create a buildx builder.
```shell
$docker context create dind --description "Docker in Docker" --docker host=tcp://127.0.0.1:2375
$docker context use dind # should also set the buildx context on docker version > 23.0.0
$docker buildx use dind
```

### Additional info
If you want to start, for some reason, **arm64** dind image on **amd64** machine, it will fail  
with error:
`level=error msg="failure getting variant" error="getCPUInfo for pattern: Cpu architecture: not found"`.
Basically, `containerd` fails.
You should not need this, run the machine native image, and with qemu installed you should be able
to build multi-arch images.


## Useful environment variables
```properties
BUILDKIT_PROGRESS=plain
DOCKER_BUILDKIT=1
```