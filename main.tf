variable "AWS_ACCESS_KEY" {
  description = "The access key"
}

variable "AWS_SECRET_KEY" {
  description = "The secret key"
}

provider "aws" {
  access_key              = "${var.AWS_ACCESS_KEY}"
  secret_key              = "${var.AWS_SECRET_KEY}"
  region                  = "ap-south-1"
  profile                 = "terraform_user"
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default = 8080
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "elb" {
  name = "terraform-example-elb"
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#resource "aws_instance" "web" {
#  ami = "ami-0912f71e06545ad88"
#  instance_type = "t2.micro"
#
#  vpc_security_group_ids = ["${aws_security_group.instance.id}"]
#
#
#  user_data = <<-EOF
#              #!/bin/bash
#              echo "Hello, World" > index.html
#              nohup busybox httpd -f -p "${var.server_port}" &
#              EOF
#  tags {
#    Name = "sample_web"
#  }
#}

resource "aws_launch_configuration" "example" {
  image_id = "ami-0912f71e06545ad88"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.instance.id}"]
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF
  lifecycle {
    create_before_destroy = true
  }
}

data "aws_availability_zones" "all" {}

resource "aws_autoscaling_group" "example" {
  launch_configuration = "${aws_launch_configuration.example.id}"
  availability_zones = ["${data.aws_availability_zones.all.names}"]
  min_size = 1
  max_size = 2

  load_balancers = ["${aws_elb.example.name}"]
  health_check_type = "ELB"

  tag {
    key = "Name"
    value = "terraform-asg-example"
    propagate_at_launch = true
  }
}

resource "aws_elb" "example" {
  name = "terraform-asg-example"
  availability_zones = ["${data.aws_availability_zones.all.names}"]
  security_groups = ["${aws_security_group.elb.id}"]

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:${var.server_port}/"
  }

  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "${var.server_port}"
    instance_protocol = "http"
  }
}

// output "public_ip" {
//   value = "${aws_instance.web.public_ip}"
// }
output "elb_dns_name" {
  value = "${aws_elb.example.dns_name}"
}
