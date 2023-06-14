## kinda

> this is a lab for understanding kubernetes better

This is a Dockerfile for creating a Kubernetes cluster using the kubeadm tool. The Dockerfile installs the necessary packages for kubeadm, kubelet, and kubectl, initializes the Kubernetes cluster using kubeadm, installs the Calico network plugin, exposes the Kubernetes API server, and starts the Kubernetes API server.

### Usage
To use this Dockerfile, follow these steps:
```shell
# For Building the docker image, first clone the repo:
git clone https://github.com/miladhzzzz/kinda

# Move to the Kinda Directory:
cd kinda

# Use Make to build and run the image
make build && make run

# Extract the kubeconfig

chmod +x Extract_kubeconfig.sh && ./Extract_kubeconfig.sh
```


> This Dockerfile is for demonstration purposes only and should not be used in production environments. It is recommended to use a more secure method for initializing the Kubernetes cluster, such as kubeadm's built-in token-based authentication method.