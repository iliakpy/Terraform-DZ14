provider "aws" {
 region = "eu-central-1"
}

resource "aws_instance" "terraform" {
 ami = "ami-0e342d72b12109f91"
 instance_type = "t2.micro"
 key_name = "my-key1"
 security_groups = ["ESecurity2"]

 connection {
    type        = "ssh"
    user        = "ubuntu"
    agent       = false
    private_key = "${file("~/.ssh/my-key1.pem")}"
  } 

 provisioner "file"{
   source      = "index.html"
   destination = "~/index.html"
 }

 provisioner "remote-exec" {
    inline = [
         "sudo apt update",
         "sudo apt install -y nginx",
         "sudo cp ~/index.html /var/www/html/index.html", 
    ]
 }
}
