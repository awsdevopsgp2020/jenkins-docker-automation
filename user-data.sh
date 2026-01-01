
#!/bin/bash
apt update -y

# Install Java
apt install openjdk-17-jdk -y

# Install Docker
apt install docker.io -y
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
apt install jenkins -y

usermod -aG docker jenkins
systemctl restart jenkins
