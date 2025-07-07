#!/bin/bash

vpc_id=$(aws ec2 create-vpc --cidr-block 172.16.0.0/16 --tag-specification "ResourceType=vpc,Tags=[{Key=Name,Value=Kaizen}]" --query Vpc.VpcId --output text)

subnet1_id=$(aws ec2 create-subnet --vpc-id $vpc_id --cidr-block 172.16.1.0/24 --query Subnet.SubnetId --output text)

igw_id=$(aws ec2 create-internet-gateway --query InternetGateway.InternetGatewayId --output text)

aws ec2 attach-internet-gateway --vpc-id $vpc_id --internet-gateway-id $igw_id

rt_id=$(aws ec2 create-route-table --vpc-id $vpc_id --query RouteTable.RouteTableId --output text)

aws ec2 create-route --route-table-id $rt_id --destination-cidr-block 0.0.0.0/0 --gateway-id $igw_id

aws ec2 associate-route-table --subnet-id $subnet1_id --route-table-id $rt_id