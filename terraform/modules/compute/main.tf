data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"] // AMI name contains :
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "ec2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [ var.vpc_security_group_ids ]
  user_data = var.user_data_path
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  tags = {
    Name = var.instance_name
  }
}

resource "aws_iam_role" "ec2_role" {
  name = "EC2SecretsManagerRole"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole"
            ],
            "Principal": {
                "Service": [
                    "ec2.amazonaws.com"
                ]
            }
        }
    ]
})
  tags = {
    tag-key = "EC2SecretRole"
  }
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_secret_profile"
  role = aws_iam_role.ec2_role.name
}


resource "aws_iam_policy" "secrets_policy" {
  name = "SecretsManagerPolicy"
  description = "EC2 Secret Access"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "BasePermissions",
            "Effect": "Allow",
            "Action": [
                "secretsmanager:GetSecretValue",
            ],
            "Resource": "*"
        },
    ]
})
}

resource "aws_iam_role_policy_attachment" "attach_secrets_policy" {
  policy_arn = aws_iam_policy.secrets_policy.arn
  role       = aws_iam_role.ec2_role.name
}

output "instance_id" {
  value = aws_instance.ec2.id
}