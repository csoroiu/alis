# Instructions for multi-arch build
There are 3 things to configure:
- install multi-arch binary support
- enable docker buildx builds
- dns resolution when doing the build from outside company vpn

## Install multi-arch support
### A simple way
You simply need to run (if you haven't installed qemu-user-static in a different way):
```bash
$ docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
```

This is explained here: https://github.com/multiarch/qemu-user-static#usage

### Preferably
On **Arch Linux** you may install `binfmt-qemu-static` from **AUR**. 
By doing so, you do not need to run the above command every time you need to run
a multi-arch build.

## Enable docker buildx builds
First step would be to enable experimental features inside `~/.docker/config.json`.
Inside that file you need to add the `experimental` field with value `enabled`.
```json
{
  "experimental": "enabled"
}
```

Also, next step is to configure a new build driver.
```bash
$ docker buildx create --use --name multiplatform
```

In order to see the existing drivers you may run `docker buildx ls` and 
`docker buildx use <name>` to switch to a different one.

## Dns resolution
[Here](dns%20resolution%20for%20docker%20and%20buildx.md) you may find the necessary info.