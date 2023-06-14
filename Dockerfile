FROM alpine:latest

# Install curl
RUN apk add --no-cache curl

# Install Kubernetes binaries
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x./kubectl
RUN mv./kubectl /usr/local/bin/kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kube-apiserver
RUN chmod +x./kube-apiserver
RUN mv./kube-apiserver /usr/local/bin/kube-apiserver
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kube-controller-manager
RUN chmod +x./kube-controller-manager
RUN mv./kube-controller-manager /usr/local/bin/kube-controller-manager
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kube-scheduler
RUN chmod +x./kube-scheduler
RUN mv./kube-scheduler /usr/local/bin/kube-scheduler

# Initialize the Kubernetes control plane
RUN kubeadm init --pod-network-cidr=10.244.0.0/16

# Copy the kubeconfig file to the default location
RUN mkdir -p $HOME/.kube
RUN cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
RUN chown $(id -u):$(id -g) $HOME/.kube/config

# Install the Calico network plugin
RUN kubectl apply -f https://docs.projectcalico.org/v3.14/manifests/calico.yaml

# Expose the Kubernetes API server
EXPOSE 6443

# Start the Kubernetes API server
CMD ["kube-apiserver", "--bind-address=0.0.0.0", "--insecure-port=0", "--secure-port=6443", "--advertise-address=0.0.0.0", "--etcd-servers=http://localhost:2379"]