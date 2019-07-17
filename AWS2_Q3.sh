#creating vpc
aws ec2 create-vpc --cidr-block 10.0.0.0/24 --region us-east-1 > vpcDetails.json
vpcid=$(jq -r ".Vpc.VpcId" vpcDetails.json)

#creating subnets
aws ec2 create-subnet --vpc-id $vpcid --cidr-block 10.0.0.0/27 --availability-zone us-east-1a --region us-east-1 > pubsub1.json
aws ec2 create-subnet --vpc-id $vpcid --cidr-block 10.0.0.32/27 --availability-zone us-east-1a --region us-east-1 > prisub1.json
aws ec2 create-subnet --vpc-id $vpcid --cidr-block 10.0.0.64/27 --availability-zone us-east-1b --region us-east-1 > pubsub2.json
aws ec2 create-subnet --vpc-id $vpcid --cidr-block 10.0.0.96/27 --availability-zone us-east-1b --region us-east-1 > prisub2.json
aws ec2 create-subnet --vpc-id $vpcid --cidr-block 10.0.0.128/27 --availability-zone us-east-1c --region us-east-1 > pubsub3.json
aws ec2 create-subnet --vpc-id $vpcid --cidr-block 10.0.0.160/27 --availability-zone us-east-1c --region us-east-1 > prisub3.json

#id of public subnets
s1id=$(jq -r ".Subnet.SubnetId" pubsub1.json)
s2id=$(jq -r ".Subnet.SubnetId" pubsub2.json)
s3id=$(jq -r ".Subnet.SubnetId" pubsub3.json)

#create Internet Gateway
aws ec2 create-internet-gateway --region us-east-1 > ig.json
igid=$(jq -r ".InternetGateway.InternetGatewayId" ig.json)

#attaching gateway
aws ec2 attach-internet-gateway --vpc-id "$vpcid" --internet-gateway-id "$igid" --region us-east-1

aws ec2 create-route-table --vpc-id "$vpcid" --region us-east-1 > rt.json
rtid=$(jq -r ".RouteTable.RouteTableId" rt.json)
aws ec2 create-route --route-table-id "$rtid" --destination-cidr-block 0.0.0.0/0 --gateway-id "$igid" --region us-east-1

aws ec2 associate-route-table --subnet-id "$s1id" --route-table-id "$rtid" --region us-east-1
aws ec2 associate-route-table --subnet-id "$s2id" --route-table-id "$rtid" --region us-east-1
aws ec2 associate-route-table --subnet-id "$s3id" --route-table-id "$rtid" --region us-east-1

aws ec2 modify-subnet-attribute --subnet-id "$s1id" --map-public-ip-on-launch --region us-east-1
aws ec2 modify-subnet-attribute --subnet-id "$s2id" --map-public-ip-on-launch --region us-east-1
aws ec2 modify-subnet-attribute --subnet-id "$s3id" --map-public-ip-on-launch --region us-east-1

