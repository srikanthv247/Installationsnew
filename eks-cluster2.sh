#Provide the region   us-east-1 

#Provide the output format like json or table 

 curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp sudo mv /tmp/eksctl /usr/local/bin 

 eksctl version  

eksctl create cluster \ --name charan \ --region us-east-1 \ --version 1.32 \ --zones us-east-1a,us-east-1b \ --without-nodegroup 

curl -LO "https://dl.k8s.io/release/$(curl -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"  

chmod +x kubectl  

sudo mv kubectl /usr/local/bin/ 

kubectl version --client  

 eksctl utils associate-iam-oidc-provider --region us-east-1 --cluster Kumarv1 --approve  

 eksctl delete nodegroup --cluster=Charan --region=us-east-1 --name=workernode #(it will delete if we have any existing cluster errors) 

eksctl create nodegroup --cluster=Kumarv1 --region=us-east-1 --name=workernode --node-type=t3.small --nodes=2 --nodes-min=2 --nodes-max=4 --node-volume-size=20 --ssh-access --ssh-public-key=kubernetes --managed --asg-access --external-dns-access --full-ecr-access --appmesh-access --alb-ingress-access 

curl -LO https://dl.k8s.io/release/v1.21.14/bin/linux/amd64/kubectl 

sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl 

kubectl version --client 

kubectl get node  
