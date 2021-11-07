# Container commands
**Containerd** that comes with k3s has the default address:
`/run/k3s/containerd/containerd.sock`

While the one that you install from official repositories 
has the default address: `/run/containerd/containerd.sock`

## How to list namespaces from containerd socket
1. `sudo ctr ns ls`
2. `sudo ctr -a /run/containerd/containerd.sock ns ls`
3. `sudo ctr -a /run/docker/containerd/containerd.sock ns ls`
4. `sudo ctr -a /run/k3s/containerd/containerd.sock ns ls`

The containerd **namespace** for **docker** containers is: **moby**
The containerd **namespace** for **k8s** and **k3s** containers is: **k8s.io**

## How to list containers from containerd for docker
1. `sudo ctr -a /var/run/containerd/containerd.sock -n moby c ls`
2. `sudo ctr -n moby c ls`

## How to list the containers started by docker using runc
1. `sudo runc --root /run/docker/runtime-runc/moby list`


# Docker
The folowing commands should list the same containers:
1. `docker ps`
2. `sudo ctr -n moby c ls`
3. `sudo runc --root /run/docker/runtime-runc/moby list`

# Kubernetes
The folowing commands should list the same containers:
1. `sudo ctr -n k8s.io c ls`
2. `sudo runc --root /run/containerd/runc/k8s.io list`
3. `sudo crictl ps`. `crictl ps` lists only running containers.

In the output of **ctr** and **runc** you may see additional 
containers associated to the pods by the k8s runtime.