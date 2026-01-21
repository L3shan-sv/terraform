resource "aws_vpc" "demo-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "demo-vpc"
  }
}

resource "aws_subnet" "private-subnet-1" {
  vpc_id     = aws_vpc.demo-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "private-subnet-1"
  }
}
resource "aws_subnet" "private-subnet-2" {
  vpc_id     = aws_vpc.demo-vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "private-subnet-2"
  }
} 

 resource "aws_subnet" "public-subnet-1" {
  vpc_id     = aws_vpc.demo-vpc.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "public-subnet"
  }
}
 resource "aws_subnet" "public-subnet-2" {
  vpc_id     = aws_vpc.demo-vpc.id
  cidr_block = "10.0.4.0/24"

  tags = {
    Name = "public-subnet-2"
  }
}
resource "aws_internet_gateway" "gw-demo" {
  vpc_id = aws_vpc.demo-vpc.id

  tags = {
    Name = "gw-demo"
  }
}

resource "aws_route_table" "public-rt-1" {
  vpc_id = aws_vpc.demo-vpc.id

  # IPv4 internet
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw-demo.id
  }

  # Optional: IPv6 internet if using IPv6
  # route {
  #   ipv6_cidr_block      = "::/0"
  #   egress_only_gateway_id = aws_egress_only_internet_gateway.example.id
  # }

  tags = {
    Name = "public-rt-1"
  }
}
resource "aws_route_table" "public-rt-2" {
  vpc_id = aws_vpc.demo-vpc.id

  # IPv4 internet
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw-demo.id
  }

  # Optional: IPv6 internet if using IPv6
  # route {
  #   ipv6_cidr_block      = "::/0"
  #   egress_only_gateway_id = aws_egress_only_internet_gateway.example.id
  # }

  tags = {
    Name = "public-rt-2"
  }
}
resource "aws_route_table" "private-rt-1" {
  vpc_id = aws_vpc.demo-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-1.id
  }

  tags = {
    Name = "private-rt-1"
  }
}
resource "aws_route_table" "private-rt-2" {
  vpc_id = aws_vpc.demo-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-1.id
  }

  tags = {
    Name = "private-rt-2"
  }
}

resource "aws_route_table_association" "private-assoc-1" {
  subnet_id      = aws_subnet.private-subnet-1.id
  route_table_id = aws_route_table.private-rt-1.id
}
resource "aws_route_table_association" "private-assoc-2" {
  subnet_id      = aws_subnet.private-subnet-2.id
  route_table_id = aws_route_table.private-rt-2.id
}

 

/// SECURITY GROUP CONFIG
resource "aws_security_group" "security-1" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.demo-vpc.id

  tags = {
    Name = "security-1"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ingress-ipv4" {
  security_group_id = aws_security_group.security-1.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "ingress-ipv6" {
  security_group_id = aws_security_group.security-1.id
  cidr_ipv6         = aws_vpc.demo-vpc.ipv6_cidr_block
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.security-1.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.security-1.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
resource "aws_eip" "nat_eip-1" {
  
  tags = {
    Name = "nat-eip-1"
  }
}
resource "aws_eip" "nat_eip-2" {
  
  tags = {
    Name = "nat-eip-2"
  }
}


resource "aws_nat_gateway" "nat-1" {
  allocation_id = aws_eip.nat_eip-1.id
  subnet_id     = aws_subnet.public-subnet-1.id
  

  tags = {
    Name = "nat-1"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw-demo]
} 
resource "aws_nat_gateway" "nat-2" {
  allocation_id = aws_eip.nat_eip-2.id
  subnet_id     = aws_subnet.public-subnet-2.id
  

  tags = {
    Name = "nat-2"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw-demo]
}