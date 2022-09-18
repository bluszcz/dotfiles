#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
cd /tmp/
sudo DEBIAN_FRONTEND=noninteractive apt install unzip -y
unzip /tmp/awscliv2.zip
sudo /tmp/aws/install