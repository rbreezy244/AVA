#Get AVA Instance ID Variable
$avaInstanceId = aws ec2 describe-verified-access-instances --filters "Name=tag:Name,Values=ava_instance_ncc" --query 'VerifiedAccessInstances[0].VerifiedAccessInstanceId' --output text

#Get User Trust Provider ID
$userTrustProviderId = aws ec2 describe-verified-access-trust-providers --filters "Name=tag:Name,Values=oidc-trust-provider" --query 'VerifiedAccessTrustProviders[0].VerifiedAccessTrustProviderId' --output text

#Get AVA Access Group ID
$avaAccessGroupID = aws ec2 describe-verified-access-groups --filters "Name=tag:Name,Values=ava_access_group_ncc" --query 'VerifiedAccessGroups[0].VerifiedAccessGroupId' --output text

#Delete Access Group
aws ec2 delete-verified-access-group --verified-access-group-id $avaAccessGroupID

#Detach Trust Provider
aws ec2 detach-verified-access-trust-provider --verified-access-instance-id $avaInstanceId --verified-access-trust-provider-id $userTrustProviderId

#Delete AVA Instance
aws ec2 delete-verified-access-instance --verified-access-instance-id $avaInstanceId

#Delete User Trust Provider
aws ec2 delete-verified-access-trust-provider --verified-access-trust-provider-id $userTrustProviderId