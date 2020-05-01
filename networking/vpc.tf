resource "aws_vpc" "main" {
  # Referencing the base_cidr_block variable from variable.tf allows the network address
  # to be changed without modifying the configuration.
  cidr_block = var.base_cidr_block
  enable_dns_hostnames = "true"
  tags          = {
    CREATED_ON        = "20200423"
    }
}

#Add internet gateway 
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id
    tags          = {
    CREATED_ON        = "20200423"
    }
}

#Collect information about available zones as a list
data "aws_availability_zones" "availability_zones" {
    state = "available"
}

#Create public subnet in each availability zone
resource "aws_subnet" "public" {
  # Count is reserve key word inside resource and terraform create resources
  # based on count 
  count = length(data.aws_availability_zones.availability_zones.names)

  # For each subnet, use one of the specified availability zones.
  availability_zone = data.aws_availability_zones.availability_zones.names[count.index]

  # By referencing the aws_vpc.main object, Terraform knows that the subnet
  # must be created only after the VPC is created.
  vpc_id = aws_vpc.main.id

  # Built-in functions and operators can be used for simple transformations of
  # values, such as computing a subnet address. Here we create a /20 prefix for
  # each subnet, using consecutive addresses for each availability zone,
  # such as 10.1.16.0/20 .
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 4, count.index+1)
  tags          = {
    CREATED_ON        = "20200423"
    }
}

#Create private subnet in each availability zone
resource "aws_subnet" "private" {
  # Count is reserve key word inside resource and terraform create resources
  # based on count 
  count = length(data.aws_availability_zones.availability_zones.names)

  # For each subnet, use one of the specified availability zones.
  availability_zone = data.aws_availability_zones.availability_zones.names[count.index]

  # By referencing the aws_vpc.main object, Terraform knows that the subnet
  # must be created only after the VPC is created.
  vpc_id = aws_vpc.main.id

  # Built-in functions and operators can be used for simple transformations of
  # values, such as computing a subnet address. Here we create a /20 prefix for
  # each subnet, using consecutive addresses for each availability zone,
  # such as 10.1.16.0/20 .
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 4, count.index+1)
  tags          = {
    CREATED_ON        = "20200423"
    }
}
#create routes table
resource "aws_route_table" "routes_table" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
    tags          = {
    CREATED_ON        = "20200423"
    }
}

#Associate route table with each subnet
resource "aws_route_table_association" "rta-subnet" {
    count = length(data.aws_availability_zones.availability_zones.names)
    subnet_id = aws_subnet.azpw.*.id[count.index]
    route_table_id = aws_route_table.routes_table.id
     
}

