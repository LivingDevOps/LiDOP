# LiDOP
A easy to use DevOps playground. Can be started local or in AWS.


## Getting Started
These instructions will get you a copy of the project up and running on your local machine for development and testing purposes
[Installation](./install/Readme.md)


## High Level Architecture

| Layer                     | Tools               | Description
| ------------------------- | ------------------- | ----------------------
| `Plugins`                 | Code                | Example code and pipelines
| `Test installation`       | Serverspec          | Test Installation
| `Provisioning`            | Ansible             | Install LiDOP
| `Infrastructure option 1` | AWS Cloud Formation | For starting LiDOP in AWS
| `Infrastructure option 2` | Terraform           | For starting LiDOP in cloud (AWS)
| `Infrastructure option 3` | Vagrant             | For starting LiDOP on a local machine

# Special note for the Vagrant way

## Prerequisites
The following Software must be installed to run LiDOP
- Virtualbox https://www.virtualbox.org/wiki/Downloads
- Vagrant https://www.vagrantup.com/downloads.html

## Starting
*On a windows machine, use cmd or powershell and not git bash for executing vagrant up*
```
git clone https://github.com/LivingDevOps/LiDOP.git
cd lidop
vagrant up
```

# Infrastructure general

The default and testet infrastrucutre OS, is a Ubuntu 16.10.
The following changes will be executed during the ansible execution (be care full, if you run the ansible-playbook on a existing machine)

## Prerequisites
One Jenkins Slave is installed on the host machine, therefore we change the ssh settings on the host machine:
- enable login with user and password

## Software
The following software will be installed during the ansible execution:
- nfs-kernel-server
- java jre (for jenkins slave)
- python-pip
- python-pexpect
- dos2unix

## Network
The DNS settings will be changed. There is a Consul service running which will be the default DNS resolver for the host.


# Provisioning
The installation is done with Ansible (99% of it). There is one script, which will install ansible on the host machine (yes we execute ansible direct on the host).

## High Level process
1. Execution of ./scripts/ansible.sh. This script installs Ansible and needed ansible modules.
2. Execution of the ansible playbook ./install/install.yml
    - Ansible Role "lidop_host_preparation". Installation and configuration of the host
    - Ansible Role "docker". Installation and configuration of docker
    - Ansible Role "lidop". Installation and configuration of LiDOP

# Test installation
The most of the ansible steps are testet after each step. Never the less, there are some server spec tests which will be executed at the end of the installation

## Plugins
description is coming soon