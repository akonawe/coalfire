# EC2 Instance

resource "aws_instance" "CoalFireEC2" {
  ami           = "ami-08e637cea2f053dfa" # us-east-1
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.public_sub2.id}"
  associate_public_ip_address = true
  vpc_security_group_ids = ["sg-0f293c63b5b644a0f"]
  key_name = "mykey"
  tags = {
      Name = "CoalFireEC2"
  }
}

#EBS Configuration

resource "aws_ebs_volume" "CoalFireEC2_EBS" {
  availability_zone = "us-east-1b"
  size              = 20

  tags = {
    Name = "CoalFireEC2_EBS"
  }
}


resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.CoalFireEC2_EBS.id
  instance_id = aws_instance.CoalFireEC2.id
}
