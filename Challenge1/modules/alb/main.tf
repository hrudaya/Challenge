module "iam_instance_profile" {
  source  = "terraform-aws-modules/iip/aws"
  actions = ["logs:*", "rds:*"] 
}

#  This is a fairly simple cloud init file. All it does is install some packages, create a configuration file (/etc/server.conf),
#  fetch application code (deployment.zip) and start the server  
data "cloudinit_config" "config" {
  gzip          = true
  base64_encode = true
  part {
    content_type = "text/cloud-config"
    content      = templatefile("${path.module}/cloud_config.yaml", var.db_config) 
  }
}
# Get the AMI id's
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  owners = ["099720109477"]
}

resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Generating key pair  
resource "aws_key_pair" "generated_key" {
  key_name   = var.ssh_keypair
  public_key = tls_private_key.example.public_key_openssh
}

# Create pem locally
provisioner "local-exec" { 
    command = "echo '${tls_private_key.pk.private_key_pem}' > ./${var.namespace}.pem"
}

# Create S3 Bucket   
resource "aws_s3_bucket" "private_access" {
   bucket = "${var.namespace}"
   acl = "private"
   versioning {
      enabled = true
   }
   tags = {
     Name = "Bucket1"
     Environment = var.namespace
   }
} 

# Copy Key to S3 Bucket    
resource "aws_s3_bucket_object" "login-path" {
    bucket = "${aws_s3_bucket.private_access.bucket.id}"
    acl    = "private"
    key    = "login-path"
    source = "./${var.namespace}.pem"
}  

# Remove pem from local system
provisioner "local-exec" { 
    command = "rm -rf ./${var.namespace}.pem"
}  
  
  
  
  
resource "aws_launch_template" "webserver" {
  name_prefix   = var.namespace
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = "${aws_key_pair.generated_key.key_name}"
  iam_instance_profile {
    name = module.iam_instance_profile.name
  }
  vpc_security_group_ids = [var.sg.webserver]
}

# The Autoscaling Groups data source allows access to the list of AWS ASGs within a specific region. 
# This will allow you to pass a list of AutoScaling Groups to other resources.  
resource "aws_autoscaling_group" "webserver" {
  name                = "${var.namespace}-asg"
  min_size            = 1
  max_size            = 3
  vpc_zone_identifier = var.vpc.private_subnets
  target_group_arns   = module.alb.target_group_arns
  launch_template {
    id      = aws_launch_template.webserver.id
    version = aws_launch_template.webserver.latest_version
  }
}

module "alb" {
  source             = "terraform-aws-modules/alb/aws"
  version            = "~> 5.0"
  name               = var.namespace
  load_balancer_type = "application"
  vpc_id             = var.vpc.vpc_id
  subnets            = var.vpc.public_subnets
  security_groups    = [var.sg.lb]

# Loadbalancer listens to port 80 and which is mapped to instance port 8080  
  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  target_groups = [
    { name_prefix      = "webserver"
      backend_protocol = "HTTP"
      backend_port     = 8080
      target_type      = "instance"
    }
  ]
}
