#----------------Provider configuration--------------
provider "aws" {
  region = "${var.region}"
}

#---------------Creating key pair-------------------
resource "aws_key_pair" "ssh_key" {
  key_name   = "deployer-key" 
  public_key = "${file("/Users/AnkurKS/.ssh/terra-deployer.pub")}"
}

#--------------aws ec2 instance configuration---------
resource "aws_instance" "webservice" {
  ami                    = "${var.ami}"
  instance_type          = #"AMI_ID_HERE"
  tags {
    Name                 = "webservice"
    FunctionalContext    = "demo"
  }
  key_name               = "${aws_key_pair.ssh_key.key_name}"
  availability_zone      = "${var.availability_zone_1}"
  vpc_security_group_ids = ["${aws_security_group.webservice_sg.id}"]
  subnet_id              = "${var.private_subnet_zone_1}"
}

resource "aws_instance" "webserver" {
  ami                    = "${var.ami}"
  instance_type          = #"AMI_ID_HERE"
  tags {
    Name                 = "webserver"
    FunctionalContext    = "demo"
  }
  key_name               = "${aws_key_pair.ssh_key.key_name}"
  availability_zone      = "${var.availability_zone_1}"
  vpc_security_group_ids = ["${aws_security_group.webserver_sg.id}"]
  subnet_id              = "${var.private_subnet_zone_1}"
}

#--------------elastic load balancer configuration------
resource "aws_elb" "elb" {
  name                  = "elb"
  subnets               = ["${var.public_subnet_zone_1}", "${var.public_subnet_zone_2}"]
  security_groups       = ["${aws_security_group.elb_sg.id}"]
  listener {
    instance_port       = "${var.elb["app_instance_port"]}"
    instance_protocol   = "http"
    lb_port             = "${var.elb["app_lb_port"]}"
    lb_protocol         = "http"
  }
  health_check {
    healthy_threshold   = "${var.elb["healthy_threshold"]}"
    unhealthy_threshold = "${var.elb["unhealthy_threshold"]}"
    timeout             = "${var.elb["timeout"]}"
    target              = "${var.elb["target"]}"
    interval            = "${var.elb["interval"]}"
  }
  instances             = ["${aws_instance.webserver.id}"]
}


#---------------Security group configuration---------------
resource "aws_security_group" "elb_sg" {
  name        = "elb-sg"
  vpc_id      = "${var.vpc_id}"
  description = "Used for terraform demo"
  ingress {
    from_port   = 80
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "webservice_sg" {
  name   = "webservice-sg"
  vpc_id = "${var.vpc_id}"
  ingress {
    from_port   = 7000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "webserver_sg" {
  name   = "webserver-sg"
  vpc_id = "${var.vpc_id}"
  ingress {
    from_port   = 8000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
