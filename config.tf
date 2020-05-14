  
provider "aws" {
 region = "eu-central-1"
}

resource "aws_s3_bucket" "hw" {
  bucket = "terrahw"
  acl = "public-read"
}
resource "aws_instance" "gitmvn" {
 ami = "ami-0e342d72b12109f91"
 instance_type = "t2.micro"
 key_name = "my-key4"
 security_groups = ["launch-wizard-2"]
 
 tags = {
    Name = "Git and Maven machine"
  }
 connection {
    type        = "ssh"
    user        = "ubuntu"
    agent       = false
    private_key = "${file("~/.ssh/my-key4.pem")}"
 }
  
  provisioner "file"{
   source      = "~/.aws/credentials"
   destination = "~/credentials"
 }


 provisioner "remote-exec" {
    inline = [
         "sudo apt update && sudo apt install -y git && sudo apt install -y maven && sudo apt install -y awscli",
         "git clone https://github.com/PZA-git/boxfuse3.git myapp",
         "cd myapp && mvn package",
         "cd ..",
         "sudo mkdir ~/.aws",
         "sudo mv ~/credentials ~/.aws/credentials",         
         "aws s3 cp ~/myapp/target/hello-1.0.war s3://terrahw --acl public-read",
         ]
 }
}


resource "aws_instance" "tomcat8" {
 ami = "ami-0e342d72b12109f91"
 instance_type = "t2.micro"
 key_name = "my-key4"
 security_groups = ["launch-wizard-2"]
 tags = {
    Name = "Tomcat8 machine"
  }
 connection {
    type        = "ssh"
    user        = "ubuntu"
    agent       = false
    private_key = "${file("~/.ssh/my-key4.pem")}"
  } 
 
 provisioner "remote-exec" {
    inline = [
         "sudo apt update",
         "sudo apt install -y tomcat8",
         "sudo sleep 1m",
         "sudo wget -P /var/lib/tomcat8/webapps/ https://terrahw.s3.eu-central-1.amazonaws.com/hello-1.0.war",
    ]
 }
}
