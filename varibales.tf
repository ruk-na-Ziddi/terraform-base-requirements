variable "region" {
	defualt = "us-east-1"
}

variable "ami" {
	defualt = "ami-2423d532"
}

variable "instance" {
	defualt = "t2.micro"
}

variable "availability_zone_1" {
	defualt = "us-east-1a"
}

variable "availability_zone_2" {
	defualt = "us-east-1b"
}

variable "server_elb" {
	type = "map"
	defualt = {
		app_instance_port = 80
		app_lb_port = 8009
		healthy_threshold = 2
		unhealthy_threshold = 2 
		timeout = 3
		target = "TCP:22"
		interval = 30
	}
}

variable "service_elb" {
	type = "map"
	defualt = {
		app_instance_port = 8080
		app_lb_port = 8080
		healthy_threshold = 2
		unhealthy_threshold = 2 
		timeout = 3
		target = "TCP:22"
		interval = 30
	}
}
