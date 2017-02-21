variable "region" {
}

variable "vpc_id" {
}

variable "ami" {
}

variable "availability_zone_1" {
}

variable "availability_zone_2" {
}

variable "private_subnet_zone_1" {
}

variable "private_subnet_zone_2" {
}

variable "public_subnet_zone_2" {
}

variable "public_subnet_zone_2" {
}

variable "elb" {
	type = "map"
	defualt = {
		app_instance_port =
		app_lb_port = 
		healthy_threshold =
		unhealthy_threshold = 
		timeout =
		target = 
		interval = 
	}
}
