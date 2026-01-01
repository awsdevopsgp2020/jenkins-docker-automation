#!/bin/bash
set -e

apt update -y
apt install -y openjdk-17-jdk docker.io git
systemctl start docker
systemctl enable docker
usermod -aG docker ubuntu

# Jenkins install
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

apt update -y
apt install -y jenkins

# 🔥 REAL PORT FIX (systemd)
mkdir -p /etc/systemd/system/jenkins.service.d
cat <<EOF >/etc/systemd/system/jenkins.service.d/override.conf
[Service]
Environment="JENKINS_PORT=8081"
EOF

systemctl daemon-reload
systemctl restart jenkins

usermod -aG docker jenkins

# Web app
cd /home/ubuntu
git clone https://github.com/awsdevopsgp2020/git-jenkins-docker.git
cd git-jenkins-docker/webapp
docker build -t webapp .
docker run -d -p 80:80 webapp
