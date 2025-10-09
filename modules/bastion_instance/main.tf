#creating required resources for bastion host
resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Allow SSH access to bastion host"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_instance" "bastion" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_1_id # Public subnet ID
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  key_name                    = var.key_name # Name of your EC2 keypair for SSH
  associate_public_ip_address = true

  tags = {
    Name = "Bastion-Host"
  }


  connection {
    type        = "ssh"
    user        = "ubuntu"                                              # username for your EC2 instance
    private_key = file("C:/Users/mittu/Documents/key-pair/ec2_key.pem") # Replace with the path to your private key
    host        = self.public_ip                                        #self isliye bcoz hum already resource ke andar hai, resource ke andar nahi hote toh aws_instance.resource_name.public_ip yeh use karte
  }

  provisioner "file" {
    source      = "C:/Users/mittu/Documents/key-pair/ec2_key.pem" # Replace with the path to your local file
    destination = "/home/ubuntu/ec2_key.pem"                      # Replace with the path on the remote instance
  }
  /*
  provisioner "remote-exec" {
    inline = [ "sudo ssh -i ec2_key.pem ubuntu@${data.aws_instances.asg-instances.instances[0]}", ]
  }

  provisioner "remote-exec" {
  inline = [
    <<-EOF
    sudo tee /var/www/html/index.html <<EOT
    <!DOCTYPE html>
    <html>
      <head>
        <title>Beach</title>
      </head>
      <body>
        <h1>Welcome to My Page!</h1>
        <p>This is a paragraph of text on my simple webpage.</p>
        <p>You can add more content here.</p>
      </body>
    </html>
    EOT
    EOF
  ]
  }

  provisioner "remote-exec" {
    inline = [ "python -m http.server 8000", ]
  }

*/
}