#!/bin/sh -eux

echo "###########################################################"
echo "Install packages"
echo "###########################################################"
sudo apt-get update

sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common \
    default-jre \
    nfs-kernel-server \
    dos2unix 

echo "###########################################################"
echo "Install Docker"
echo "###########################################################"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update
sudo apt-get install -y docker-ce \
    python-pip

pip install docker
pip install docker-compose
pip install python-consul

echo "###########################################################"
echo "Install Docker Compose"
echo "###########################################################"
sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
