variable "deployment_name" {
    type = string
    description = "value of deployment name"
    default = "cloudwatch-dashboard"
}

variable "timeout" {
    type = number
    description = "value of timeout"
    default = 30
}

variable "memory_size" {
    type = number
    description = "value of memory for lambda"
    default = 1024
}

variable "vpc_id" {
    type = string
    description = "value of vpc id"
    default = ""
}

variable "vpc_subnet_ids" {
    type = list(string)
    description = "value of vpc subnet ids"
    default = []
}

variable "vpc_security_group_ids" {
    type = list(string)
    description = "value of vpc security group ids"
    default = [] 
}

variable "policies" {
    type = list(string)
    description = "value of policies"
    default = []
  
}