#!/bin/sh

sudo apt update -y

#Installation of Docker
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt-cache policy docker-ce
sudo apt install -y docker-ce

#Docker without the use of sudo
sudo usermod -aG docker ${USER}
sudo usermod -aG docker adminuser


#Installation of Golang
sudo wget https://go.dev/dl/go1.18.5.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.18.5.linux-amd64.tar.gz
printf 'export PATH=$PATH:/usr/local/go/bin' >> /etc/profile
source /etc/profile

#Instalation of make

sudo apt install make

#Instalation of Git

sudo apt install -y git-all

cd /home/adminuser

git clone https://github.com/textileio/powergate


