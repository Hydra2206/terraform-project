#!/bin/bash
sudo apt update

scp C:/Users/mittu/Documents/key-pair/ec2_key.pem username@remote_host:/path/to/remote/directory


sudo ssh -i ec2_key.pem ubuntu@${data.aws_instances.asg-instances.instances[0]}
