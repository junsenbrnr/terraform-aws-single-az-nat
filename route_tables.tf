resource "aws_route_table" "public" {
    tags = {
        Name = "rtb_public-${var.vpc_name}"
    }

    vpc_id = "${aws_vpc.vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.igw.id}"
    }
}

resource "aws_route_table_association" "add_bastion_subnets_to_public_route_table" {
    count = 1
    subnet_id = "${element(aws_subnet.bastion.*.id, count.index)}"
    route_table_id = "${aws_route_table.public.id}"
    depends_on = ["aws_route_table.public"]
}

resource "aws_route_table_association" "add_public_subnets_to_public_route_table" {
    count = 1
    subnet_id = "${element(aws_subnet.public.*.id, count.index)}"
    route_table_id = "${aws_route_table.public.id}"
    depends_on = ["aws_route_table.public"]
}

resource "aws_route_table_association" "add_nat_subnets_to_public_route_table" {
    count = 1
    subnet_id = "${aws_subnet.nat.id}"
    route_table_id = "${element(aws_route_table.public.*.id, count.index)}"
    depends_on = ["aws_route_table.public"]
}

resource "aws_route_table" "private" {
    tags = {
        Name = "rtb_private-${var.vpc_name}"
    }

    vpc_id = "${aws_vpc.vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        instance_id = "${aws_instance.nat.id}"
    }
}

resource "aws_route_table_association" "assign_private_subnets_to_private_route_table" {
    count = 1
    subnet_id = "${element(aws_subnet.private.*.id, count.index)}"
    route_table_id = "${aws_route_table.private.id}"
    depends_on = ["aws_route_table.private"]
}