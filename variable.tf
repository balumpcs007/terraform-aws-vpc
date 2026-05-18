variable "cidr_block" {
    type = string
  
}

variable "project_name" {
    type = string
}

variable "environmet" {
    type = string
  
}

variable "vpc_tags" {
    type = map
    default = {}
  
}

variable "igw_tags" {
    type = map
    default = {}
  
}

variable "public_cidr_block" {
    type = list
  
}

variable "public_subnet_tags" {
    type = map 
    default = {}
  
}

variable "private_cidr_block" {
    type = list
  
}

variable "private_subnet_tags" {
    type = map 
    default = {}
  
}

variable "database_cidr_block" {
    type = list
  
}

variable "database_subnet_tags" {
    type = map 
    default = {}
  
}

variable "public_route_table_tags" {
    type = map 
    default = {}
  
}

variable "private_route_table_tags" {
    type = map 
    default = {}
  
}

variable "database_route_table_tags" {
    type = map 
    default = {}
  
}

variable "eip_tags" {
    type = map 
    default = {}
  
}

variable "nat_gateway_tags" {
    type = map
    default = {}
}






