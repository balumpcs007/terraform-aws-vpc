# Terraform aws VPC
This module creates the following resources
* VPC
* IGW
* 2 Public subnets in us-east-1a and us-east-1b
* 2 Private subnets in us-east-1a and us-east-1b
* 2 Database subnets in us-east-1a and us-east-1b 
* Public route table
* Private route table
* Database route table
* EIP for NAT
* Nat Gateway in Public subnet 1a AZ
* IGW route is added to public route table
* Route table association with subnets
* vpc to default peering
* Public route table to default vpc route
* Default vpc main route table to create vpc route
### Inputs
* vpc_cidr - (Required). User must supply the CIDR for VPC.
* project_name - (Required). User must supply the project name.