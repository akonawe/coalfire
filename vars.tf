variable "AWS_ACCESS_KEY" {
default = ""   
}

variable "AWS_secret_key" {
    default = ""
}

variable "AWS_Region" {
  default = "us-east-1"
}

variable "AMIS" {
  type = map(string)
  default = {
    us-east-1 = "ami-08e637cea2f053dfa" #red hat linux 9
  }
}

variable "aws_instancetype" {
 default = "t2.micro"
}
