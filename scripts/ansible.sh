#!/usr/bin/env bash
echo "###########################################################"
echo "Install ansible"
echo "###########################################################"
sudo apt-get update
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