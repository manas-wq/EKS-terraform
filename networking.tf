##### VPC   ####
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "${var.env}-vpc"
  }
}

##### Subnets  #####
resource "aws_subnet" "private_AZ1" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.0.0/19"
  availability_zone = var.availability_zones[0]

  tags = {
    Name = "${var.env}-private-${var.availability_zones[0]}-subnet"

    #to create load balancer
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/${var.env}-${var.eks_name}" = "owned"
  }
  
}

resource "aws_subnet" "private_AZ2" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.32.0/19"
  availability_zone = var.availability_zones[1]

  tags = {
    Name = "${var.env}-private-${var.availability_zones[1]}-subnet"

    #to create load balancer
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/${var.env}-${var.eks_name}" = "owned"
  }
  

}

resource "aws_subnet" "public_AZ1" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.64.0/19"
  availability_zone = var.availability_zones[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env}-public-${var.availability_zones[0]}-subnet"
     "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/${var.env}-${var.eks_name}" = "owned"
    
  }

}

resource "aws_subnet" "public_AZ2" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.96.0/19"
  availability_zone = var.availability_zones[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env}-public-${var.availability_zones[1]}-subnet"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/${var.env}-${var.eks_name}" = "owned"
  }
  
}

##### Internet gateway   ####
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id

    tags = {
      Name = "${var.env}-igw"
    }
  
}

##### Elastic IP   #####
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "${var.env}-nat"
  }
  
}

##### nat gateway   #####
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.public_AZ1.id

  tags = {
    Name = "${var.env}-nat"
  }

  depends_on = [aws_internet_gateway.igw]
}

##### Route tables   ####
## private
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route{
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${var.env}-private-rt"
    
  }
  
}

## public
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route{
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.env}-public-rt"
  }
  
}

##### Route table association   ####
resource "aws_route_table_association" "private_AZ1" {
  subnet_id = aws_subnet.private_AZ1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_AZ2" {
  subnet_id = aws_subnet.private_AZ2.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "public_AZ1" {
  subnet_id = aws_subnet.public_AZ1.id
  route_table_id = aws_route_table.public.id
} 

resource "aws_route_table_association" "public_AZ2" {
  subnet_id = aws_subnet.public_AZ2.id
  route_table_id = aws_route_table.public.id
} 
