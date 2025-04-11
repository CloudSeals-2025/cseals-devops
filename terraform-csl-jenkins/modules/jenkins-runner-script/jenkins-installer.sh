#!/bin/bash
sudo yum update
yes | sudo yum install java-17-amazon-corretto-devel
sudo yum update
echo "Waiting for 30 seconds before installing the jenkins package..."
sleep 30
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum update
yes | sudo yum install jenkins
sudo systemctl daemon-reload
sudo systemctl enable jenkins
sudo systemctl start jenkins
sleep 30
echo "Waiting for 30 seconds before installing the Terraform..."
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform