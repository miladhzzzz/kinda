#!/bin/sh


# Install conntrack via curl and tar
apk add --no-cache curl tar iptables build-base && \
curl -LO https://github.com/markcaudill/conntrack/releases/download/v1.4.6/conntrack-1.4.6.tar.gz && \
tar -xzf conntrack-1.4.6.tar.gz && \
cd conntrack-1.4.6 && \
./configure && \
make && \
make install && \
cd.. && \
rm -rf conntrack-1.4.6*

# Install required packages
curl -LO https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.19.0/crictl-v1.19.0-linux-amd64.tar.gz
tar -xzf crictl-v1.19.0-linux-amd64.tar.gz
mv crictl /usr/local/bin/
rm crictl-v1.19.0-linux-amd64.tar.gz

# Install Kubernetes binaries
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kube-apiserver
chmod +x ./kube-apiserver
mv ./kube-apiserver /usr/local/bin/kube-apiserver
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kube-controller-manager
chmod +x ./kube-controller-manager
mv ./kube-controller-manager /usr/local/bin/kube-controller-manager
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kube-scheduler
chmod +x ./kube-scheduler
mv ./kube-scheduler /usr/local/bin/kube-scheduler
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubelet
chmod +x ./kubelet
mv ./kubelet /usr/local/bin/kubelet
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubeadm
chmod +x ./kubeadm
mv ./kubeadm /usr/local/bin/kubeadm

# Initialize the Kubernetes control plane
kubeadm init --pod-network-cidr=10.244.0.0/16

# Copy the kubeconfig file to the default location
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

# Install the Calico network plugin
kubectl apply -f https://docs.projectcalico.org/v3.14/manifests/calico.yaml

# Expose the Kubernetes API server
kubectl expose service kube-apiserver --port=443 --target-port=6443 --name=kube-apiserver --type=ClusterIP

# Start the Kubernetes API server
kube-apiserver --bind-address=0.0.0.0 --insecure-port=0 --secure-port=443 --advertise-address=0.0.0.0 --etcd-servers=http://localhost:2379