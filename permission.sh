# Get your IAM user ARN
USER_ARN=$(aws sts get-caller-identity --query Arn --output text)

# Add access entry
#Use your own ClusterName 
aws eks create-access-entry \
  --cluster-name KENBOUCH-EKS-Cluster \ 
  --region us-east-1 \
  --principal-arn "$USER_ARN"


aws eks associate-access-policy \
  --cluster-name KENBOUCH-EKS-Cluster \
  --region us-east-1 \
  --principal-arn "$USER_ARN" \
  --policy-arn arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy \
  --access-scope '{"type":"cluster"}'
    