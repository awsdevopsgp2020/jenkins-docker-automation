#!/bin/bash
set -e

# Update system
apt update -y

# Install Java
apt install -y openjdk-17-jdk

# Install Docker
apt install -y docker.io git
systemctl start docker
systemctl enable docker
usermod -aG docker ubuntu

# Install Jenkins
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

apt update -y
apt install -y jenkins

# 🔥 CHANGE JENKINS PORT TO 8081
sed -i 's/HTTP_PORT=8080/HTTP_PORT=8081/' /etc/default/jenkins

# Permissions
usermod -aG docker jenkins

# Restart services
systemctl daemon-reexec
systemctl restart jenkins
systemctl restart docker

# -----------------------------
# DEPLOY SAMPLE WEB APP
# -----------------------------
cd /home/ubuntu
git clone https://github.com/awsdevopsgp2020/git-jenkins-docker.git
cd git-jenkins-docker/webapp

docker build -t webapp .
docker run -d -p 80:80 --name webapp webapp
