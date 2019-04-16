#!/usr/bin/env bash
echo "###########################################################"
echo "Wait for init steps"
echo "###########################################################"
while fuser /var/lib/apt/lists/lock >/dev/null 2>&1 ; do
 echo 'waiting for apt to release the lock'
 sleep 1
done

while fuser /var/lib/dpkg/lock >/dev/null 2>&1 ; do
 echo 'waiting for dpkg to release the lock'
 sleep 1
done

sudo systemctl stop apt-daily.timer
sudo systemctl disable apt-daily.timer
sudo systemctl disable apt-daily.service
sudo systemctl daemon-reload
sudo apt-get -y remove unattended-upgrades

echo "###########################################################"
echo "Install ansible"
echo "###########################################################"
sudo apt-get update --fix-missing -y
sudo apt-get install -y software-properties-common
sudo apt-add-repository -y ppa:ansible/ansible   
sudo apt-get update

sudo apt-get install -y \
    ansible  \
    python-pip \
    python-pexpect \
    dos2unix

echo "###########################################################"
ansible --version
echo "###########################################################"
