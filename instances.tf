resource "aws_instance" "bastion" {
    tags {
        Name = "bastion"
    }

    ami = "${var.base_ami_id}"
    instance_type = "${var.instance_type}"
    key_name = "${var.bastion_key_name}"
    associate_public_ip_address = true
    vpc_security_group_ids = ["${aws_security_group.sg_bastion.id}"]
    subnet_id = "${aws_subnet.bastion.id}"

    root_block_device {
        volume_type = "gp2"
        volume_size = 8
    }

    user_data = <<-EOF
                #!/bin/bash
                sudo yum update -y
                EOF
}

resource "aws_instance" "public" {
    tags {
        Name = "public"
    }

    ami = "${var.base_ami_id}"
    instance_type = "${var.instance_type}"
    key_name = "${var.public_key_name}"
    associate_public_ip_address = true
    vpc_security_group_ids = ["${aws_security_group.sg_public.id}"]
    subnet_id = "${aws_subnet.public.id}"

    root_block_device {
        volume_type = "gp2"
        volume_size = 8
    }

    user_data = <<-EOF
                #!/bin/bash
                sudo yum update -y
                sudo amazon-linux-extras install php7.2 -y
                sudo yum install httpd -y
                sudo systemctl start httpd
                EOF
}

resource "aws_instance" "private" {
    tags {
        Name = "private"
    }

    ami = "${var.base_ami_id}"
    instance_type = "${var.instance_type}"
    key_name = "${var.private_key_name}"
    associate_public_ip_address = false
    vpc_security_group_ids = ["${aws_security_group.sg_private.id}"]
    subnet_id = "${aws_subnet.private.id}"

    root_block_device {
        volume_type = "gp2"
        volume_size = 8
    }

    user_data = <<-EOF
                #!/bin/bash
                sudo yum update -y
                sudo amazon-linux-extras install lamp-mariadb10.2-php7.2 -y
                sudo yum install mariadb-server -y
                sudo systemctl start mariadb
                EOF
}

resource "aws_instance" "nat" {
    tags {
        Name = "nat"
    }

    ami = "${var.nat_ami_id}"
    instance_type = "${var.instance_type}"
    key_name = "${var.nat_key_name}"
    associate_public_ip_address = true
    vpc_security_group_ids = ["${aws_security_group.sg_nat.id}"]
    subnet_id = "${aws_subnet.nat.id}"
    source_dest_check = false

    root_block_device {
        volume_type = "gp2"
        volume_size = 8
    }

    user_data = <<-EOF
                #!/bin/bash
                sudo yum update -y
                EOF
}