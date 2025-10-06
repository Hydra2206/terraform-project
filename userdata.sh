#!/bin/bash
sleep 60
sudo ssh -i ec2_key.pem ubuntu@${data.aws_instances.asg-instances.instances[0]}

sudo tee /var/www/html/index.html <<EOF
<html>
<head><title>My Portfolio</title></head>
<body>
<h1>Terraform Project Server 1</h1>
<p>Instance ID: $INSTANCE_ID</p>
<p>Hello Mittu YOYO</p>
</body>
</html>
EOF

python3 -m http.server 8000