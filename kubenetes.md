# Bootstrapping Single-Node Kubernetes Cluster on Ubuntu 18.04

## Resources:
https://github.com/hobby-kube/guide
https://github.com/kubernetes/kubeadm/tree/master/docs/design
https://kubernetes.io/docs/setup/independent/install-kubeadm/
https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/


## Install Docker
```
sudo apt-get update && sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update && sudo apt-get install -y docker-ce
```

## Setup Docker
1. Replace the Docker service start command
```
sudo sed -i 's/ExecStart.*/ExecStart=/usr/bin/dockerd' /lib/systemd/system/docker.service
```
2. Place the docker configuration in `/etc/docker/daemon.json`

3. Place the certs in `/etc/ssl/docker/`
- ca.pem
- server-cert.pem
- server-key.pem

## Install firewall (might not be needed for clusters < 1 node)
```
apt update
apt upgrade
apt install ufw
ufw allow ssh # sshd on port 22, be careful to not get locked out!
ufw allow 6443 # remote, secure Kubernetes API access
ufw allow 80
ufw allow 443
ufw default deny incoming # deny traffic on every other port, on any interface
ufw enable
```

## Install Kubernetes
```
sudo apt-get update
sudo apt-

sudo kubeadm init # optional flag for extra SANs to use for the API Server serving certificate `--apiserver-cert-extra-sans=<my domain name>`
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
sudo sysctl net.bridge.bridge-nf-call-iptables=1
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
kubectl taint nodes --all node-role.kubernetes.io/master-
```

## Setup Ingress
```
# TODO figure this out
```


## Tear Down
```
kubectl drain <node name> --delete-local-data --force --ignore-daemonsets
kubectl delete node <node name>
kubeadm reset
```
After "Tear Down", to bootstrap cluster again, redo above steps starting with kubeadm init command.
