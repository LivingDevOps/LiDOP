#!/usr/bin/env bash
echo "###########################################################"
echo "Install ansible"
echo "###########################################################"
apt-get update
apt-get install -y software-properties-common
apt-add-repository -y ppa:ansible/ansible   
apt-get update

sudo apt-get install -y \
    ansible  \
    python-pip \
    python-pexpect

echo "###########################################################"
ansible --version
echo "###########################################################"