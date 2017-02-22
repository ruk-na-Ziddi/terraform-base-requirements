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
  instance_type          = "${var.instance}"
  tags {
    Name                 = "webservice-${count.index + 1}"
    FunctionalContext    = "demo"
    Purpose              = "webservice"
  }
  key_name               = "${aws_key_pair.ssh_key.key_name}"
  availability_zone      = "${var.availability_zone_1}"
  count                  = 2
  security_groups        = ["sg-913505ed"]
  subnet_id              = "subnet-4e69e22b"
}

resource "aws_instance" "webserver" {
  ami                    = "${var.ami}"
  instance_type          = "${var.instance}"
  tags {
    Name                 = "webserver"
    FunctionalContext    = "demo"
  }
  key_name               = "${aws_key_pair.ssh_key.key_name}"
  availability_zone      = "${var.availability_zone_1}"
  security_groups        = ["sg-913505ed"]
  subnet_id              = "subnet-4e69e22b"
}

#--------------elastic load balancer configuration------
resource "aws_elb" "server_elb" {
  name                  = "server-elb"
  security_groups       = ["sg-913505ed"]
  subnets               = ["subnet-4e69e22b", "subnet-300a970c"]
  listener {
    instance_port       = "${var.server_elb["app_instance_port"]}"
    instance_protocol   = "http"
    lb_port             = "${var.server_elb["app_lb_port"]}"
    lb_protocol         = "http"
  }
  health_check {
    healthy_threshold   = "${var.server_elb["healthy_threshold"]}"
    unhealthy_threshold = "${var.server_elb["unhealthy_threshold"]}"
    timeout             = "${var.server_elb["timeout"]}"
    target              = "${var.server_elb["target"]}"
    interval            = "${var.server_elb["interval"]}"
  }
  instances             = ["${aws_instance.webserver.id}"]
}

resource "aws_elb" "service_elb" {
  name                  = "service-elb"
  security_groups       = ["sg-913505ed"]
  subnets               = ["subnet-4e69e22b", "subnet-300a970c"]
  listener {
    instance_port       = "${var.service_elb["app_instance_port"]}"
    instance_protocol   = "http"
    lb_port             = "${var.service_elb["app_lb_port"]}"
    lb_protocol         = "http"
  }
  health_check {
    healthy_threshold   = "${var.service_elb["healthy_threshold"]}"
    unhealthy_threshold = "${var.service_elb["unhealthy_threshold"]}"
    timeout             = "${var.service_elb["timeout"]}"
    target              = "${var.service_elb["target"]}"
    interval            = "${var.service_elb["interval"]}"
  }
  instances             = ["${aws_instance.webservice.*.id}"]
}
