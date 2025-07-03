#!/bin/bash

# Download and install eksctl
echo "Installing eksctl..."
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version

# Create EKS cluster without nodegroup
echo "Creating EKS cluster without nodegroup..."
eksctl create cluster \
  --name Kubernetes \
  --region us-east-1 \
  --version 1.32 \
  --zones us-east-1a,us-east-1b \
  --without-nodegroup

# Update kubeconfig to connect kubectl with cluster
echo "Updating kubeconfig..."
aws eks --region us-east-1 update-kubeconfig --name Kubernetes

# Download and install latest kubectl
echo "Installing kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
kubectl version --client

# Associate IAM OIDC provider
echo "Associating IAM OIDC Provider..."
eksctl utils associate-iam-oidc-provider --region us-east-1 --cluster Kubernetes --approve 

# Delete existing nodegroup (if exists)
echo "Deleting existing nodegroup (if any)..."
eksctl delete nodegroup --cluster=Kubernetes --region=us-east-1 --name=workernode || echo "No existing nodegroup found"

# Create new nodegroup
echo "Creating nodegroup..."
eksctl create nodegroup \
  --cluster=Kubernetes \
  --region=us-east-1 \
  --name=workernode \
  --node-type t3.small \
  --nodes 2 \
  --nodes-min 2 \
  --nodes-max 4 \
  --node-volume-size 20 \
  --ssh-access \
  --ssh-public-key kubernetes \
  --managed \
  --asg-access \
  --external-dns-access \
  --full-ecr-access \
  --appmesh-access \
  --alb-ingress-access 

# (Optional) Reinstall specific kubectl version if needed (v1.21.14)
# Commented out to avoid overwrite, uncomment only if required

# echo "Installing kubectl v1.21.14 (optional overwrite)..."
# curl -LO https://dl.k8s.io/release/v1.21.14/bin/linux/amd64/kubectl
# sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
# kubectl version --client

# Get nodes
echo "Getting node list..."
kubectl get nodes --output=wide
