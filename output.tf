output "webserver_ip" {
	value = "${aws_instance.webserver.private_ip}"
}

output "webservice_ip" {
	value = ["${aws_instance.webservice.*.private_ip}"]
}

output "elb_url" {
	value = "${aws_elb.server_elb.dns_name}"
}

output "service_elb_url" {
	value = "${aws_elb.service_elb.dns_name}"
}
