#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a
sudo apt update
sudo NEEDRESTART_MODE=a DEBIAN_FRONTEND=noninteractive apt upgrade -y
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
