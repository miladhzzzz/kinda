FROM k8s.gcr.io/kube-apiserver:v1.21.2

# Install kubeadm, kubelet, and kubectl
RUN apt-get update && apt-get install -y apt-transport-https curl
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list
RUN apt-get update && apt-get install -y kubelet kubeadm kubectl

# Initialize the Kubernetes cluster
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