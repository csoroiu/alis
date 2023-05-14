# Container commands
**Containerd** that ships with k3s has the default address:
```text
/run/k3s/containerd/containerd.sock
```

**Containerd** that ships with docker has the default address:
`/run/docker/containerd/containerd.sock`

**Containerd** that you install from official repositories
has the default address: `/run/containerd/containerd.sock`

## List namespaces from a containerd socket
1. ```shell
   $sudo ctr ns ls
   ```
2. ```shell
   $sudo ctr -a /run/containerd/containerd.sock ns ls
   ```
3. ```shell
   $sudo ctr -a /run/docker/containerd/containerd.sock ns ls
   ```
4. ```shell
   $sudo ctr -a /run/k3s/containerd/containerd.sock ns ls
   ```

The containerd **namespace** for **docker** containers is: **moby**.
The containerd **namespace** for **k8s** and **k3s** containers is: **k8s.io**.

## List containers started by docker using containerd
1. ```shell
   $sudo ctr -a /run/containerd/containerd.sock -n moby c ls
   ```
2. ```shell
   $sudo ctr -a /run/docker/containerd/containerd.sock -n moby c ls
   ```
3. ```shell
   $sudo ctr -n moby c ls
   ```

## List containers started by docker using runc
```shell
$sudo runc --root /run/runtime-runc/moby list
```
```shell
$sudo runc --root /run/docker/runtime-runc/moby list
```

**Runc** has the default root `/run/runc`.

# Docker
The following commands should list the same containers:
```shell
$docker ps
```
```shell
$sudo ctr -n moby c ls
```
```shell
$sudo runc --root /run/docker/runtime-runc/moby list
```

# Kubernetes
The following commands should list the same containers:

```shell
$sudo ctr -n k8s.io c ls
```
```shell
$sudo runc --root /run/containerd/runc/k8s.io list
```
```shell
# `crictl ps` lists only running containers.
$sudo crictl ps 
```

In the output of **ctr** and **runc** you may see additional 
containers associated to the pods by the **k8s** runtime.