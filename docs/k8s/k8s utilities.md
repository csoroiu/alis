# kubectl
### Install on arm64:
1. `curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/arm64/kubectl"`
2. `sudo install kubectl /usr/local/bin`

### Install on amd64:
1. `curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"`
2. `sudo install kubectl /usr/local/bin`

### Enable bash completion
1. `mkdir -p ~/.kubectl`
2. `kubectl completion bash >~/.kubectl/kubectl.completion.bash.inc`
3. inside `~/.bashrc` add: `source $HOME/.kubectl/kubectl.completion.bash.inc`

# helm
### Install
Git repository is: https://github.com/helm/helm.
1. `curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash`

### Enable bash completion
1. `mkdir -p ~/.kubectl`
2. `helm completion bash >~/.kubectl/helm.completion.bash.inc`
3. inside `~/.bashrc` add: `source $HOME/.kubectl/helm.completion.bash.inc`

# kubectx
### Install
Git repository is: https://github.com/ahmetb/kubectx.git.
1. `git clone https://github.com/ahmetb/kubectx.git ~/.kubectx`

# node-shell
### Install
Git repository is: https://github.com/kvaps/kubectl-node-shell
1. `curl -LO https://github.com/kvaps/kubectl-node-shell/raw/master/kubectl-node_shell`
2. `sudo install kubectl-node_shell /usr/local/bin/`

# nfs-subdir-external-provisioner 
### Install
Git repository is: [repository][nfs-provisioner-repo].
A very useful readme can also be found [there][nfs-provisioner-readme].
1. `helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/`
2. ```
   helm install my-release nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
    --set nfs.server=x.x.x.x \
    --set nfs.path=/exported/path \
    --set storageClass.name=managed-nfs-storage
   ```
### Uninstall
1. helm delete my-release

### Examples
#### Install
```
e.g.
 kubectl create namespace nfs-provisioner
 helm install -n nfs-provisioner nfs-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
    --set nfs.server=bagend.slh \
    --set nfs.path=/volume1/k3s-nfs/ \
    --set storageClass.name=managed-nfs-storage \
    --set storageClass.defaultClass=true \
    --set replicaCount=2
```
#### Upgrade
`helm upgrade -n nfs-provisioner nfs-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner`

#### Delete
`helm delete -n nfs-provisioner nfs-provisioner`

#### Change default storage class
Information can be found [here][k8s-change-default-storage-class].
1. You need to set the **defaultClass** flag to false for the previous 
default storage class `kubectl patch storageclass local-path -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'`
2. If not done before, set the **defaultClass** flag to false for
the new storage class `kubectl patch storageclass managed-nfs-storage -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'`

[nfs-provisioner-repo]: https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner
[nfs-provisioner-readme]: https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner/blob/master/charts/nfs-subdir-external-provisioner/README.md
[k8s-change-default-storage-class]: https://kubernetes.io/docs/tasks/administer-cluster/change-default-storage-class/

