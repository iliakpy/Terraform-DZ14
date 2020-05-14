  
provider "aws" {
 region = "us-east-2"
}

resource "aws_s3_bucket" "dz" {
  bucket = "terraform"
  acl = "public-read"
}
resource "aws_instance" "gitmvn" {
 ami = "ami-07c1207a9d40bc3bd"
 instance_type = "t2.micro"
 key_name = "my-key1"
 security_groups = ["EMySecurity1"]
 
 tags = {
    Name = "Git and Maven machine"
  }
 connection {
    type        = "ssh"
    user        = "ubuntu"
    agent       = false
    private_key = "${file("~/.ssh/my-key1.pem")}"
 }
  
  provisioner "file"{
   source      = "~/.aws/credentials"
   destination = "~/credentials"
 }


 provisioner "remote-exec" {
    inline = [
         "sudo apt update && sudo apt install -y git && sudo apt install -y maven && sudo apt install -y awscli",
         "git clone https://github.com/iliak2/boxfuse3.git myapp",
         "cd myapp && mvn package",
         "cd ..",
         "sudo mkdir ~/.aws",
         "sudo mv ~/credentials ~/.aws/credentials",         
         "aws s3 cp ~/myapp/target/hello-1.0.war s3://terraform --acl public-read",
         ]
 }
}


resource "aws_instance" "tomcat8" {
 ami = "ami-07c1207a9d40bc3bd"
 instance_type = "t2.micro"
 key_name = "my-key1"
 security_groups = ["EMySecurity1"]
 tags = {
    Name = "Tomcat8 machine"
  }
 connection {
    type        = "ssh"
    user        = "ubuntu"
    agent       = false
    private_key = "${file("~/.ssh/my-key1.pem")}"
  } 
 
 provisioner "remote-exec" {
    inline = [
         "sudo apt update",
         "sudo apt install -y tomcat8",
         "sudo sleep 1m",
         "sudo wget -P /var/lib/tomcat8/webapps/ https://terraform.s3.eu-central-1.amazonaws.com/hello-1.0.war",
    ]
 }
}
