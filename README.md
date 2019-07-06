# terraform-single-az-nat

## A simple example on building AWS infrastructure using Terraform

> WARNING: It is *NOT* recommended you build your production infrastructure in this manner. This is only in one AZ, not using RDS *AND* is using a NAT instance to connect what is in the private subnet to the outside world.

## Up and running
### What is this doing?
The code in this repository is building a LAMP stack in a single AZ within AWS. A total of four instances are being created within their corresponding subnets:

* bastion - you can only SSH into the other instance from here
* nat - routes traffic from the private subnet to the outside world
* public - httpd and PHP 7.2
* private - MariaDB 10.2

### AWS
Create an AWS account if you haven't already done so. Once your account has been created follow the 
[instructions](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html) on installing and configuring the AWS CLI.

### Terraform
Install [Terraform](https://www.terraform.io/downloads.html) if you haven't already done so. 

### Code
Download or clone this repository.

##### vars.tf and terraform.tfvars
Copy `terraform.tfvars.example` to `terraform.tfvars`. There are several default variables set in `vars.tf` such as `region`, `vpc_name`, etc. If you're eligible for AWS' "free tier", leave `instance_type` commented out as you won't be charged<sup>*</sup>. Feel free to change the others based on your location and personal preferences. The default values set for the following variables must be replaced:

* `known_cidrs` - use your CIDR otherwise SSH is open to the world
* `key_name` - use your own [key](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html#having-ec2-create-your-key-pair) and add them to the [ssh-agent](https://aws.amazon.com/blogs/security/securely-connect-to-linux-instances-running-in-a-private-amazon-vpc/)

Once the necessary variables have been replaced, it's time to build.

### Build
Run: `terraform init` to download the AWS provider plugin

Run: `terraform plan -out=[NAME-YOUR-PLAN]` to generate the plan that Terraform will use to build your infrastructure

Run: `terraform apply "[NAME-YOUR-PLAN]"` to build out your infrastructure
> If you supply the [NAME-YOUR-PLAN], Terraform will not prompt you `Do you want to perform these actions?`

With everything built, in terminal you should see outputs of the bastion, public and private instances. Find:
* the public IP of the bastion instance
* the public and private IP of the public instance
* the private IP of the private instance

SSH into the bastion instance using its public IP and then SSH into the private instance. Run through the `mysql_secure_installation` process and create a database granting access to a user of your choice along with its password to the private IP of the public instance.

For example: 
```
grant all privileges on YOUR-DATABASE.* to YOUR-DB-USER@PUBLIC-INSTANCE-PRIVATE-IP identified by 'SuPeRSeCrEtPaSsWoRd';
flush privileges;
```
Close the SSH connection and now connect to the public instance. In `/var/www/html`, create a simple `index.php` page with the following contents:
```php
<?php

$link = mysqli_connect("PRIVATE-INSTANCE-PRIVATE-IP", "YOUR-DB-USER", "SuPeRSeCrEtPaSsWoRd", "YOUR-DATABASE");

if (!$link) {
    echo "Error: Unable to connect to MySQL." . PHP_EOL;
    echo "Debugging errno: " . mysqli_connect_errno() . PHP_EOL;
    echo "Debugging error: " . mysqli_connect_error() . PHP_EOL;
    exit;
}

print "Success!";

mysqli_close($link);
```
If everything worked going to the public instance's public IP in your browser would yield "Success!". Now, tear everything down because if you leave this up and running and forget about it you'll eventually get charged by AWS. You've been warned.

Run: `terraform destroy` and type in `yes` at the `Do you really want to destroy all resources?` prompt.

### Closing remarks
There's a lot of stuff going on under the hood with security groups, route tables, etc. For the sake of "simplicity", all of this information has been left out.

<sup>*</sup> There are limits to AWS' [Free Tier](https://aws.amazon.com/free/).