#ansible arch -a "yay -Sy --noconfirm k3s-bin"

#for the master nodes
export INSTALL_K3S_EXEC="server --disable servicelb --disable traefik"
curl -sfL https://get.k3s.io | sh -s -

#for the agent nodes
export K3S_URL=
export K3S_TOKEN=
curl -sfL https://get.k3s.io | sh -s -

#create server
#join server as agent
#disable servicelb
#INSTALL_K3S_EXEC
#--disable servicelb 

#label nodes
#add to all arm64 nodes with worker role
#kubectl label node -l kubernetes.io/arch=arm64 node-role.kubernetes.io/worker=true
#add worker role to single node
#kubectl label node kube2 node-role.kubernetes.io/worker=true

#taint all nodes with a label
#kubectl taint nodes -l node-role.kubernetes.io/master node-role.kubernetes.io/master=true:NoSchedule
#kubectl taint nodes -l node-role.kubernetes.io/master node-role.kubernetes.io/master=true:NoExecute
#kubectl taint nodes odroid k3s-controlplane=true:NoSchedule

# for removing a node, safest way is to:
# cordon the node
# if drain fails, taint the node with NoeExecute
# wait for pods to be moved away
# stop the service on the node
# remove the node 
# kubectl delete node <node_name>
# for k3s remove the corresponding entry from /var/lib/rancher/k3s/agent/node-password.txt
# if you don't remove the entry from the node-password filem you cannot register a new node
# back with the same name (e.g. machine was replaced)

#list namespaces in containerd/docker socket
sudo ctr -a /var/run/docker/containerd/containerd.sock ns ls

#list containers in containerd/runc for docker
sudo ctr -a /var/run/docker/containerd/containerd.sock -n moby c ls
sudo runc --root /run/docker/runtime-runc/moby list


#list namespaces in containerd/kubernetes socket
sudo ctr -a /run/k3s/containerd/containerd.sock ns ls
#list containers in containerd/runc for kubernetes
sudo ctr -a /run/k3s/containerd/containerd.sock -n k8s.io c ls
