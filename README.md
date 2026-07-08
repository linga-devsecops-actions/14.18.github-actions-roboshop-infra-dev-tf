# How to delete unnecessary files: 
```
for d in 00-vpc/ 10-sg/ 20-bastion/ 30-eks/ 40-acm/ 50-ingress-alb/ 60-ecr/ ; do
  echo "Removing from $d:"
  echo "  $d/.terraform"
  echo "  $d/.terraform.lock.hcl"
  rm -rf "$d/.terraform" "$d/.terraform.lock.hcl"
  echo "deleted files from $d"
done
```
# Infrastructure creation and deletion

```
for i in 00-vpc/ 10-sg/ 20-bastion/ 30-eks/ 40-acm/ 50-ingress-alb/ 60-ecr/ ; do cd $i ;terraform init ; cd .. ; done ;
```
```
for i in 00-vpc/ 10-sg/ 20-bastion/ 30-eks/ 40-acm/ 50-ingress-alb/ 60-ecr/ ; do cd $i; terraform plan; cd .. ; done 
```
```
for i in 00-vpc/ 10-sg/ 20-bastion/ 30-eks/ 40-acm/ 50-ingress-alb/ 60-ecr/; do cd $i; terraform apply -auto-approve; cd .. ; done 
```

```
for i in 60-ecr/ 50-ingress-alb/ 40-acm/ 30-eks/ 20-bastion/ 10-sg/ 00-vpc/; do cd $i; terraform destroy -auto-approve; cd .. ; done 
```

```
14.18.github-actions-roboshop-infra-dev-tf
14.19.github-actions-roboshop-self-hosted-runner-ec2-tf

14.20.github-actions-roboshop-reusable-workflows

14.21.github-actions-roboshop-mysql
14.22.github-actions-roboshop-mongodb
14.23.github-actions-roboshop-redis
14.24.github-actions-roboshop-rabbitmq

14.25.github-actions-roboshop-catalogue-ci
14.26.github-actions-roboshop-catalogue-cd

14.27.github-actions-roboshop-cart-ci
14.28.github-actions-roboshop-cart-cd

14.29.github-actions-roboshop-user-ci
14.30.github-actions-roboshop-user-cd

14.31.github-actions-roboshop-payment-ci
14.32.github-actions-roboshop-payment-cd

14.33.github-actions-roboshop-shipping-ci
14.34.github-actions-roboshop-shipping-cd

14.35.github-actions-roboshop-web
```
# Infrastructure

![alt text](eks-infra.svg)

Creating above infrastructure involves lot of steps, as maintained sequence we need to create
* VPC
* All security groups and rules
* Bastion Host, VPN
* EKS
* RDS
* ACM for ingress
* ALB as ingress controller
* ECR repo to host images
* CDN

## Sequence

* (Required). create VPC first
* (Required). create SG after VPC
* (Required). create bastion host. It is used to connect RDS and EKS cluster.
* (Optional). VPN, same as bastion but a windows laptop can directly connect to VPN and get access of RDS and EKS.
* (Required). RDS. Create RDS because we don't create databases in Kubernetes.
* (Required). ACM. It is required to get SSL certificates for our ALB ingress controller.
* (Required). ingress ALB is required to expose our applications to outside world.
* (Required). ECR. We need to create ECR repo to host the application images.
* (Optional). CDN is optional. but good to have.

# Github Runner actitvies:

* We creating ec2 instance and attach it to github actions


github.com/orgs/joindevops-actions/repositories
```
click on 'joindevops-actions->settings->actions--> runners->create self-hosted runner
select linux and run below commands
```

* How to see execution or installation of server? 
```
sudo less /var/log/messages
```

# Download
* Create a folder
```
$ mkdir actions-runner && cd actions-runner
```

* Download the latest runner package
```
$ curl -o actions-runner-linux-x64-2.335.1.tar.gz -L https://github.com/actions/runner/releases/download/v2.335.1/actions-runner-linux-x64-2.335.1.tar.gz
```

# Optional: Validate the hash
```
$ echo "4ef2f25285f0ae4477f1fe1e346db76d2f3ebf03824e2ddd1973a2819bf6c8cf  actions-runner-linux-x64-2.335.1.tar.gz" | shasum -a 256 -c
```

* Extract the installer
```
$ tar xzf ./actions-runner-linux-x64-2.335.1.tar.gz
```


# Configure
* Create the runner and start the configuration experience
```
$ ./config.sh --url https://github.com/linga-devsecops-actions --token BJ2A47D7OB3UR37YPMQDIVDKIKR5I
```

# Last step, run it!
```
$ ./run.sh
```
# Using your self-hosted runner: Use this YAML in your workflow file for each job
```
runs-on: self-hosted
```


* We can replace ./run.sh with below service.

* configuring runner manually using service.
```
sudo vim /etc/systemd/system/runner.service
```
```
[Unit]
Description=GitHub Actions Runner
After=network.target

[Service]
Type=simple
User=ec2-user
WorkingDirectory=/home/ec2-user/actions-runner
ExecStart=/home/ec2-user/actions-runner/run.sh
Restart=always

[Install]
WantedBy=multi-user.target
```
```
sudo systemctl enable runner
```
```
sudo systemctl start runner
```
```
sudo systemctl status runner
```


# Using your self-hosted runner
```
*  Use this YAML in your workflow file for each job
runs-on: self-hosted
```

# Another option to enable:
```
github.com/orgs/joindevops-actions/repositories

click on 'joindevops-actions->settings->actions--> runner group->default -> select 'allow public repositories`
```



**Runner configuration**
* SSH to bastion host
* run below command and configure the credentials.
```
aws configure
```
* get the kubernetes config using below command
```
aws eks update-kubeconfig --region us-east-1 --name roboshop-dev
```
* Now you should be able to connect K8 cluster
```
kubectl get nodes
```
Create a namespace
```
kubectl create namespace roboshop
```

# Installing EBISCI drivers:
# EBS Dynamic Provisioning  Steps:
1. We need to install the EBS CSI drivers in EKS cluster.
   kubectl apply -k "github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/?ref=release-1.32"
2. Your nodes should have access to connect with EBS volumes. Attach EBS CSI policy to the EC2 instance role.
3. someone on behalf of you should create EBC Volume in AWS and equivalent PV in K8s automatically --> dynamic provisioning that one is Storage class.


```
git clone https://github.com/linga-devsecops-actions/14.21.github-actions-roboshop-mysql.git
cd 14.21.github-actions-roboshop-mysql/helm
helm upgrade --install mysql . -n roboshop
kubectl get pods -n roboshop

# Checking db from mysql:
```
kubectl exec -it -n roboshop mysql-0 -- mysql -u shipping -pRoboShop@1

kubectl exec -it -n roboshop mysql-1 -- mysql -u shipping -pRoboShop@1

show databases;
use cities;
show tables;
select count(*) from cities;
select count(*) from codes;

```

How to check MySQL server logs:
```
tail -f /var/log/messages
```

git clone https://github.com/linga-devsecops-actions/14.22.github-actions-roboshop-mongodb.git
cd 14.22.github-actions-roboshop-mongodb/helm
helm upgrade --install mongodb . -n roboshop
kubectl get pods -n roboshop

git clone https://github.com/linga-devsecops-actions/14.23.github-actions-roboshop-redis.git
cd 14.23.github-actions-roboshop-redis/helm
helm upgrade --install redis . -n roboshop
kubectl get pods -n roboshop

git clone https://github.com/linga-devsecops-actions/14.24.github-actions-roboshop-rabbitmq.git
cd 14.24.github-actions-roboshop-rabbitmq/helm
helm upgrade --install rabbitmq . -n roboshop
kubectl get pods -n roboshop

```


* Update the targetgroup arn from roboshop-infra-dev to web helm charts.


# For web:

### Admin activities

# Important Note: We no need to attach this this policy ‘ElasticLoadBalancingFullAccess’ to EKS Worker node's IAM role and execute it.  It will be attached automatically when eks nodes are created.

**Ingress Controller**

Ref: https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.8/
* Connect to K8 cluster from bastion host.
* Create an IAM OIDC provider. You can skip this step if you already have one for your cluster.

# IAM OIDC Setup:
```
eksctl utils associate-iam-oidc-provider --region us-east-1 --cluster roboshop-dev --approve
```

# Create IAM Policy:
* Download an IAM policy for the LBC using one of the following commands:
```
curl -o iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.8.2/docs/install/iam_policy.json
```

* Create an IAM policy named AWSLoadBalancerControllerIAMPolicy. If you downloaded a different policy, replace iam-policy with the name of the policy that you downloaded.
```
aws iam create-policy --policy-name AWSLoadBalancerControllerIAMPolicy --policy-document file://iam-policy.json
```

# (Optional) Use Existing Policy:
```
aws iam list-policies --query "Policies[?PolicyName=='AWSLoadBalancerControllerIAMPolicy'].Arn" --output text

```

# Create IAM Service Account:
* Create a IAM role and ServiceAccount for the AWS Load Balancer controller, use the ARN from the step above

```
eksctl create iamserviceaccount \
--cluster=roboshop-dev \
--namespace=kube-system \
--name=aws-load-balancer-controller \
--attach-policy-arn=arn:aws:iam::805778285734:policy/AWSLoadBalancerControllerIAMPolicy \
--override-existing-serviceaccounts \
--region us-east-1 \
--approve
```

# Install Helm Chart:
* Add the EKS chart repo to Helm
```
helm repo add eks https://aws.github.io/eks-charts
```

* Helm install command for clusters with IRSA:

```
helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system --set clusterName=roboshop-dev
```

* Option 1 (Recommended): Reuse Existing ServiceAccount

* Since eksctl already created the IAM service account, tell Helm not to create it again.
```
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=roboshop-dev \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller
```

# Validate:
* check aws-load-balancer-controller is running in kube-system namespace.
```
kubectl get pods -n kube-system
```
