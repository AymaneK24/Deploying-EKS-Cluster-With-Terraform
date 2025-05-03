
# Deploying an EKS Cluster with Terraform

This guide provides step-by-step instructions to deploy a production-ready Amazon EKS cluster using Terraform.

## Prerequisites

Before you begin, ensure you have:

- An AWS account with IAM administrator permissions
- A user with programmatic access (access key ID and secret access key)

## Installation

### 1. Install AWS CLI

```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf awscliv2.zip aws
```

### 2. Install Terraform

```bash
TF_VERSION=$(curl -sL https://releases.hashicorp.com/terraform/index.json | jq -r '.versions[].builds[].version' | egrep -v 'rc|beta|alpha' | tail -1)
curl -LO "https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip"
unzip terraform_${TF_VERSION}_linux_amd64.zip
sudo mv -f terraform /usr/local/bin/
rm terraform_${TF_VERSION}_linux_amd64.zip
```

### 3. Install kubectl

```bash
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.28.3/2023-11-14/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
```

## Configuration

### Set up AWS credentials

```bash
aws configure
```

Enter your:

- AWS Access Key ID
- AWS Secret Access Key
- Default region name ( any region you want but prefer to use the one where you are deploying your cluster me in us-east-1)
- Default output format (e.g., `json`)

## Deployment

1. Clone the repository:

```bash
git clone https://github.com/AymaneK24/Deploying-EKS-Cluster-With-Terraform.git
cd Deploying-EKS-Cluster-With-Terraform
```

2. Initialize Terraform:

```bash
terraform init
```

3. Review the execution plan:

```bash
terraform plan
```

4. Deploy the infrastructure (takes approximately 30 minutes):

```bash
terraform apply
```

## Cluster Access

After deployment completes:

1. Configure kubectl:

```bash
aws eks update-kubeconfig --region us-east-1 --name KENBOUCH-EKS-Cluster
```

2. Verify cluster access:

```bash
kubectl cluster-info
kubectl get nodes
```

## Cluster Information

- **Cluster Name**: KENBOUCH-EKS-Cluster
- **Kubernetes Version**: 1.28
- **Node Group**:
  - Instance type: t3.medium
  - Number of nodes: 1 (fixed size)

## Clean Up

To destroy all resources when no longer needed:

```bash
terraform destroy
```

## Notes

- The EKS cluster creation typically takes 20-30 minutes to complete
- The Terraform module creates multiple AWS resources including VPC, subnets, IAM roles, and security groups, etc
- For production environments, consider modifying the node group configuration for high availability

## Troubleshooting

If you encounter issues:

- Verify your AWS credentials are correct
- Check that your IAM user has sufficient permissions
- Review CloudFormation stacks in the AWS console for errors
- Examine Terraform and CloudWatch logs for detailed error messages
- And also you can upgrade the kubectl and awscli if you already have them installed

## NB :

Even if you have IAM administrator permissions for your IAM user, AWS restrict access to the cluster so things you may need to do : 

* check access entries in the AWS Console and make sure the IAM user is part of it
* attach an iam role to the EKS Cluster from the console, and remember the arn of the role then :

```bash
aws eks update-kubeconfig --region us-east-1 --name KENBOUCH-EKS-Cluste --role-arn the-arn-of-the-role
```

then repeate the other steps, and you should be good to go !
