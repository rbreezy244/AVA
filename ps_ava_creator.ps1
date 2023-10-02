#Create AVA Instance
aws ec2 create-verified-access-instance --tag-specifications 'ResourceType=verified-access-instance,Tags=[{Key=Name,Value=ava_instance_ncc}]'

#Create Trust Provider - User
aws ec2 create-verified-access-trust-provider `
--trust-provider-type user `
--user-trust-provider-type oidc `
--oidc-options Issuer=https://enterissuerinfo.com,AuthorizationEndpoint=https://enterauthendpoint.com,TokenEndpoint=https://entertokenendpoint.com,UserInfoEndpoint=https://enteruserinfoendpoint.com,ClientId=558822,ClientSecret=Hu$h3r9,Scope=openidprofile `
--tag-specifications 'ResourceType=verified-access-trust-provider,Tags=[{Key=Name,Value=oidc-trust-provider}]' `
--policy-reference-name oidcpolicy

#Get AVA Instance ID Variable
$avaInstanceId = aws ec2 describe-verified-access-instances --filters "Name=tag:Name,Values=ava_instance_ncc" --query 'VerifiedAccessInstances[0].VerifiedAccessInstanceId' --output text

#Get User Trust Provider ID
$userTrustProviderId = aws ec2 describe-verified-access-trust-providers --filters "Name=tag:Name,Values=oidc-trust-provider" --query 'VerifiedAccessTrustProviders[0].VerifiedAccessTrustProviderId' --output text

#Attach AVA Trust Provider to instance
aws ec2 attach-verified-access-trust-provider --verified-access-instance-id $avaInstanceId --verified-access-trust-provider-id $userTrustProviderId

#Create AVA Access Group
aws ec2 create-verified-access-group --verified-access-instance-id $avaInstanceId --tag-specifications 'ResourceType=verified-access-group,Tags=[{Key=Name,Value=ava_access_group_ncc}]' 

#Get AVA Access Group ID
$avaAccessGroupID = aws ec2 describe-verified-access-groups --filters "Name=tag:Name,Values=ava_access_group_ncc" --query 'VerifiedAccessGroups[0].VerifiedAccessGroupId' --output text

#Get LoadbalencerARN -untested
#$loadBalancerArn = aws elbv2 describe-load-balancers --names YourLoadBalancerName | Select-Object -ExpandProperty LoadBalancers | Select-Object -ExpandProperty LoadBalancerArn

#Create AVA Endpoint -untested
#aws ec2 create-verified-access-endpoint `
#--verified-access-group-id $avaAccessGroupID `
#--endpoint-type load-balancer `
#--attachment-type vpc `
#--domain-certificate-arn <value> `
#--application-domain <value> `
#--endpoint-domain-prefix <value> `
#--load-balancer-options Protocol=string("http/s"),Port=integer,LoadBalancerArn=$loadBalancerArn,SubnetIds=string,string `
#--security-group-ids "string" "string" `
#--policy-document "string"