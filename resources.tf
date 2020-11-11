resource "aws_iam_role" "linux-test" {
  name = "training-role-private"
  assume_role_policy = file("iam/assume-role-policy.json")
}

resource "aws_iam_instance_profile" "training_profile" {
  name = "training-profile-private-subnet"
  role = aws_iam_role.linux-test.name
}

resource "aws_iam_role_policy_attachment" "poweruser_attach" {
  role = aws_iam_role.linux-test.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

# Define SSH key pair for our instances
resource "aws_key_pair" "default" {
  key_name = "isolated-private-subnet-key-pair"
  public_key = file(var.key_path)
}

resource "aws_instance" "linux-test" {
  count = var.instance_count
  ami = data.aws_ami.amazon_linux_ami.image_id
  instance_type = var.training_ami_size
  key_name = aws_key_pair.default.id
  subnet_id = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.sgweb.id]
  iam_instance_profile = aws_iam_instance_profile.training_profile.name
  associate_public_ip_address = false
  source_dest_check = false
  root_block_device {
    delete_on_termination = true
  }

  tags = {
    Name = format("linux-test-private%d", count.index + 1)
    Owner = "Tennis Smith"
    OS = "Linux"
    Environment = "Development"
  }
}

# This will deliberately create some un-attached EBS volumes
//resource "aws_ebs_volume" "ebs_volume" {
//  count = var.instance_count * var.ebs_volume_count + var.orphan_ebs_volume_count
//  availability_zone = element(aws_instance.linux-test.*.availability_zone, count.index)
//  size = 1
//  tags = {
//    Name = format("linux-test-orphan-%d", count.index + 1)
//    Owner = "Tennis Smith"
//  }
//}
//
//resource "aws_volume_attachment" "volume_attachement" {
//  count = var.instance_count * var.ebs_volume_count
//  volume_id = aws_ebs_volume.ebs_volume.*.id[count.index]
//  device_name = element(var.ec2_device_names, count.index)
//  instance_id = element(aws_instance.linux-test.*.id, count.index)
//}

