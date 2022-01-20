#ansible arch -a "yay -Sy --noconfirm k3s-bin"

#for the first master node (etcd)
#export INSTALL_K3S_VERSION=v1.22.3+k3s1
#export INSTALL_K3S_EXEC="server --disable servicelb --disable traefik"
export INSTALL_K3S_EXEC="server --disable servicelb"
export K3S_TOKEN=<SECRET>
export K3S_CLUSTER_INIT=true
curl -sfL https://get.k3s.io | sh -s -

#for the 2nd, 3rd master nodes (etcd)
export INSTALL_K3S_EXEC="server --disable servicelb"
export K3S_TOKEN=<SECRET>
export K3S_URL=https://<first node or clusterip>:6443
curl -sfL https://get.k3s.io | sh -s -


#for the agent nodes
#export INSTALL_K3S_VERSION=v1.22.3+k3s1
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

#kubectl label nodes k3s-upgrade=true --all

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


#Deleting labels added by system-upgrade script
SERVER_PLAN_NAME=k3s-server-v1.23.1-k3s2
AGENT_PLAN_NAME=k3s-agent-v1.23.1-k3s2
#delete upgrade plan for server nodes
k delete -n system-upgrade plan.upgrade.cattle.io/${SERVER_PLAN_NAME}
#delete upgrade plan for agent nodes
k delete -n system-upgrade plan.upgrade.cattle.io/${AGENT_PLAN_NAME}
#delete label from all server nodes
k label node -l node-role.kubernetes.io/master plan.upgrade.cattle.io/${SERVER_PLAN_NAME}-
#delete label from all agent nodes
k label node -l \!node-role.kubernetes.io/master plan.upgrade.cattle.io/${AGENT_PLAN_NAME}-
