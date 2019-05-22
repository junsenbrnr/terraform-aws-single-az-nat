resource "aws_security_group" "sg_bastion" {
    name = "sg_bastion"
    description = "Security group where bastion instances are placed"

    tags {
        Name = "sg_bastion"
    }

    vpc_id = "${aws_vpc.vpc.id}"

    ingress {
        description = "Only allow inbound 22 from know CIDRs"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = "${var.known_cidrs}"
    }

    egress {
        description = "Allow outbound 80 for software installs/updates"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        description = "Allow outbound 443 for software installs/updates"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "sg_public" {
    name = "sg_public"
    description = "Security group where public instances are placed"

    tags {
        Name = "sg_public"
    }

    vpc_id = "${aws_vpc.vpc.id}"

    ingress {
        description = "Only allow inbound 22 from sg_bastion"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        security_groups = [
            "${aws_security_group.sg_bastion.id}",
        ]
    }

    ingress {
        description = "Allow inbound 80 for web traffic"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        description = "Allow outbound 80 for software installs/updates"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        description = "Allow outbound 443 for software installs/updates"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "sg_private" {
    name = "sg_private"
    description = "Security group where private instances are placed"

    tags {
        Name = "sg_private"
    }

    vpc_id = "${aws_vpc.vpc.id}"

    ingress {
        description = "Only allow inbound 22 from sg_bastion"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        security_groups = [
            "${aws_security_group.sg_bastion.id}",
        ]
    }

    ingress {
        description = "Only allow inbound 3306 from sg_public"
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        security_groups = [
            "${aws_security_group.sg_public.id}",
        ]
    }
}

resource "aws_security_group" "sg_nat" {
    name = "sg_nat"
    description = "Security group where nat instances are placed"

    tags {
        Name = "sg_nat"
    }

    vpc_id = "${aws_vpc.vpc.id}"

    ingress {
        description = "Only allow inbound 22 from sg_bastion"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        security_groups = [
            "${aws_security_group.sg_bastion.id}",
        ]
    }

    egress {
        description = "Allow outbound 80 for software installs/updates"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        description = "Allow outbound 443 for software installs/updates"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# additional rules for sg_bastion after other
# security groups have been created
resource "aws_security_group_rule" "outbound_ssh_from_sg_bastion_to_sg_public" {
    description = "Only allow outbound 22 from sg_bastion to sg_public"
    security_group_id = "${aws_security_group.sg_bastion.id}"
    source_security_group_id = "${aws_security_group.sg_public.id}"
    type = "egress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
}

resource "aws_security_group_rule" "outbound_ssh_from_sg_bastion_to_sg_nat" {
    description = "Only allow outbound 22 from sg_bastion to sg_nat"
    security_group_id = "${aws_security_group.sg_bastion.id}"
    source_security_group_id = "${aws_security_group.sg_nat.id}"
    type = "egress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
}

resource "aws_security_group_rule" "outbound_ssh_from_sg_bastion_to_sg_private" {
    description = "Only allow outbound 22 from sg_bastion to sg_private"
    security_group_id = "${aws_security_group.sg_bastion.id}"
    source_security_group_id = "${aws_security_group.sg_private.id}"
    type = "egress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
}

# additional rules for sg_public after other
# security groups have been created
resource "aws_security_group_rule" "outbound_db_from_sg_public_to_sg_private" {
    description = "Only allow outbound 3306 from sg_public to sg_private"
    security_group_id = "${aws_security_group.sg_public.id}"
    source_security_group_id = "${aws_security_group.sg_private.id}"
    type = "egress"
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
}

# additional rules for sg_nat after other
# security groups have been created
resource "aws_security_group_rule" "inbound_80_from_sg_nat_to_sg_private" {
    description = "Only allow outbound 80 from sg_private to sg_nat"
    security_group_id = "${aws_security_group.sg_nat.id}"
    source_security_group_id = "${aws_security_group.sg_private.id}"
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
}

resource "aws_security_group_rule" "inbound_443_from_sg_nat_to_sg_private" {
    description = "Only allow outbound 443 from sg_private to sg_nat"
    security_group_id = "${aws_security_group.sg_nat.id}"
    source_security_group_id = "${aws_security_group.sg_private.id}"
    type = "ingress"
    from_port = 443
    to_port = 443
    protocol = "tcp"
}

# additional rules for sg_private after other
# security groups have been created
resource "aws_security_group_rule" "inbound_80_from_sg_private_to_sg_nat" {
    description = "Accept 80 from sg_nat"
    security_group_id = "${aws_security_group.sg_private.id}"
    source_security_group_id = "${aws_security_group.sg_nat.id}"
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
}

resource "aws_security_group_rule" "inbound_443_from_sg_private_to_sg_nat" {
    description = "Accept 443 from sg_nat"
    security_group_id = "${aws_security_group.sg_private.id}"
    source_security_group_id = "${aws_security_group.sg_nat.id}"
    type = "ingress"
    from_port = 443
    to_port = 443
    protocol = "tcp"
}

resource "aws_security_group_rule" "outbound_80_from_sg_private_to_sg_nat" {
    description = "Allow outbound 80 from sg_private to sg_nat"
    security_group_id = "${aws_security_group.sg_private.id}"
    source_security_group_id = "${aws_security_group.sg_nat.id}"
    type = "egress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
}

resource "aws_security_group_rule" "outbound_443_from_sg_private_to_sg_nat" {
    description = "Allow outbound 443 from sg_private to sg_nat"
    security_group_id = "${aws_security_group.sg_private.id}"
    source_security_group_id = "${aws_security_group.sg_nat.id}"
    type = "egress"
    from_port = 443
    to_port = 443
    protocol = "tcp"
}
