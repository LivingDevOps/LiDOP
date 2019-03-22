# LiDOP
A easy to use DevOps playground. Can be started local or in AWS.


## Getting Started
These instructions will get you a copy of the project up and running on your local machine for development and testing purposes
[Installation](./install/Readme.md)


## High Level Architecture

| Layer                     | Tools               | Description
| ------------------------- | ------------------- | ----------------------
| `Plugins`                 | Code                | Example code and pipelines
| `Test instalaltion`       | Serverspec          | Test Installation
| `Provisioning`            | Ansible             | Install LiDOP
| `Infrastructure option 1` | AWS Cloud Formation | For starting LiDOP in AWS
| `Infrastructure option 2` | Terraform           | For starting LiDOP in cloud (AWS)
| `Infrastructure option 3` | Vagrant             | For starting LiDOP on a local machine