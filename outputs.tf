
output "jenkins_url" {
  value = "http://${aws_instance.jenkins_ec2.public_ip}:8081"
}

output "webapp_url" {
  value = "http://${aws_instance.jenkins_ec2.public_ip}"
}
