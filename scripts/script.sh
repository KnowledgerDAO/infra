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


#Installation of docker-compose

sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

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

# cd powergate/docker 

# make localnet


#Instalation of IPFS

wget https://dist.ipfs.tech/kubo/v0.15.0/kubo_v0.15.0_linux-amd64.tar.gz
tar -xvzf kubo_v0.15.0_linux-amd64.tar.gz
sudo bash kubo/install.sh

ipfs init

ipfs config Addresses.API /ip4/0.0.0.0/tcp/5001
ipfs config Addresses.Gateway /ip4/0.0.0.0/tcp/9001

ipfs config --json API.HTTPHeaders.Access-Control-Allow-Origin '["*"]'
ipfs config --json API.HTTPHeaders.Access-Control-Allow-Methods '["PUT", "POST"]'

ipfs daemon &

