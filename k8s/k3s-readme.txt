#ansible arch -a "yay -Sy --noconfirm k3s-bin"
# as of https://github.com/k3s-io/k3s/issues/4234#issuecomment-947954002
#on Ubuntu >=21.10 'linux-modules-extra-raspi' has to be installed otherwise vxlan/flannel won't work
#also `nfs-common` has to be installed for nfs-provisioner

#for the first master node (etcd)
#### export INSTALL_K3S_EXEC="server --disable servicelb --disable traefik"
#export INSTALL_K3S_VERSION=v1.25.3+k3s1
export INSTALL_K3S_EXEC="server --disable servicelb"
export K3S_TOKEN=<SECRET>
export K3S_CLUSTER_INIT=true
curl -sfL https://get.k3s.io | sh -s -

#for the 2nd, 3rd master nodes (etcd)
#export INSTALL_K3S_VERSION=v1.25.3+k3s1
export INSTALL_K3S_EXEC="server --disable servicelb"
export K3S_TOKEN=<SECRET>
export K3S_URL=https://<first node or clusterip>:6443
curl -sfL https://get.k3s.io | sh -s -


#for the agent nodes
#export INSTALL_K3S_VERSION=v1.25.3+k3s1
export K3S_TOKEN=<SECRET>
export K3S_URL=https://<first node or clusterip>:6443
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

### after adding  a node
#kubectl label nodes k3s-upgrade=true --all

#taint all nodes with a label
#kubectl taint nodes -l node-role.kubernetes.io/master node-role.kubernetes.io/master=true:NoSchedule
#kubectl taint nodes -l node-role.kubernetes.io/master node-role.kubernetes.io/master=true:NoExecute
#kubectl taint nodes odroid k3s-controlplane=true:NoSchedule

# for removing a node, safest way is to:
# drain the node (or cordon)
# if drain fails, taint the node with NoExecute
# wait for pods to be moved away
# stop the service on the node
# remove the node 
# kubectl delete node <node_name>
# for k3s remove the corresponding entry from /var/lib/rancher/k3s/agent/node-password.txt
# if you don't remove the entry from the node-password filem you cannot register a new node
# back with the same name (e.g. machine was replaced)
# also, as a helper, if an etcd node cannot be added back - https://github.com/k3s-io/k3s/issues/2732#issuecomment-749484037

# you may run etcdctl container with the command:
kubectl run --rm --tty --stdin --image docker.io/rancher/coreos-etcd etcdctl --overrides='{"apiVersion":"v1","kind":"Pod","spec":{"hostNetwork":true,"restartPolicy":"Never","securityContext":{"runAsUser":0,"runAsGroup":0},"containers":[{"command":["/bin/sh"],"image":"docker.io/rancher/coreos-etcd:v3.4.16-arm64","name":"etcdctl","stdin":true,"stdinOnce":true,"tty":true,"volumeMounts":[{"mountPath":"/var/lib/rancher","name":"var-lib-rancher"}]}],"volumes":[{"name":"var-lib-rancher","hostPath":{"path":"/var/lib/rancher","type":"Directory"}}],"nodeSelector":{"node-role.kubernetes.io/etcd":"true"}}}'


#Create a new file for upgrade and run, for e.g.:
#sed -e 's/v1.32.1\([-+]\)/v1.32.2\1/g' -e 's/k3s[0-9]$/k3s1/g' -i k3s-upgrade-1.32.2-k3s1.yaml

#Deleting labels added by system-upgrade script
SERVER_PLAN_NAME=k3s-server-v1.32.1-k3s1
AGENT_PLAN_NAME=k3s-agent-v1.32.1-k3s1
#delete upgrade plan for server nodes
k delete -n system-upgrade plan.upgrade.cattle.io/${SERVER_PLAN_NAME}
#delete upgrade plan for agent nodes
k delete -n system-upgrade plan.upgrade.cattle.io/${AGENT_PLAN_NAME}
#delete label from all server nodes
k label node -l node-role.kubernetes.io/master plan.upgrade.cattle.io/${SERVER_PLAN_NAME}-
#delete label from all agent nodes
k label node -l \!node-role.kubernetes.io/master plan.upgrade.cattle.io/${AGENT_PLAN_NAME}-
