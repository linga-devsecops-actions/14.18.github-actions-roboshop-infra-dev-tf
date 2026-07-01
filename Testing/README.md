# How to remove unnecessary files:
```
for d in 10-vpc/ 20-sg/ 30-bastion/ 40-eks/ 50-ecr/; do
  echo "Removing from $d:"
  echo "  $d/.terraform"
  echo "  $d/.terraform.lock.hcl"

  rm -rf "$d/.terraform" "$d/.terraform.lock.hcl"

  echo "Deleted files from $d"
done
```

# Infrastructure creation and deletion
```
for i in 10-vpc/ 20-sg/ 40-eks/ 50-ecr/; do cd $i; terraform init ; cd .. ; done 
```
```
for i in  10-vpc/ 20-sg/ 40-eks/ 50-ecr/; do cd $i; terraform plan; cd .. ; done 
```
```
for i in  10-vpc/ 20-sg/ 40-eks/ 50-ecr/ ; do cd $i; terraform apply -auto-approve; cd .. ; done 
```
```
for i in 50-ecr/ 40-eks/ 20-sg/ 10-vpc/; do cd $i; terraform destroy -auto-approve; cd .. ; done 
```

# Application Architecture

14.5.github-actions-roboshop-infra-dev-tf
14.6.github-actions-roboshop-self-hosted-runner-ec2-tf
14.7.github-actions-roboshop-reusable-workflows
14.8.github-actions-roboshop-catalogue
14.9.github-actions-roboshop-catalogue-deploy

14.3.runner-ec2-for-github-actions
* This repo will create ec2 instance like agent node with necessary softwares.

Github Setting -> configure runner in Github.

14.4.roboshop-infra-dev-github-actions
* This repo will create eks cluster where Github actions going to run.

once its ready, then go to runner and run below commands(not using bastion server, used only vpc, vpc peering, sg, eks).

aws configure
aws s3 ls 
aws eks updatekubeconfig --region us-east-1 --name roboshop-dev
kubectl get nodes

attaching runner.

then 
reusable-workflow works as jenkins-shared-library. We can write all codes here.

catalogue and catalogue-deploy repos are applications of roboshop project.

kubectl get pods.





