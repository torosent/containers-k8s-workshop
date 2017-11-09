#! /bin/sh

#Jenkins
wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add -
echo deb http://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list
sudo apt-get update
sudo apt-get install -y jenkins
sudo systemctl start jenkins

#Docker
curl https://get.docker.com | bash
sudo usermod -aG docker azureuser
sudo usermod -aG docker jenkins