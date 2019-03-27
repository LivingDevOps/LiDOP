#!/bin/bash -eux

echo "##########################################"
echo "Download Docker Images"
echo "##########################################"
images=(ubuntu:latest \
    alpine:latest \
    maven:alpine \
    node:alpine \
    tomcat:alpine \

    livingdevops/lidop.nginx:latest \
    livingdevops/lidop.jenkins:latest \
    livingdevops/lidop.backup:latest \
    livingdevops/lidop.gitbucket:latest \
    livingdevops/lidop.serverspec:latest \
    livingdevops/lidop.sonarqube:latest \
    livingdevops/lidop.sonarqube_scanner:latest \
    livingdevops/lidop.jenkins-slave-docker:latest \

    tiredofit/self-service-password:latest\

    consul \
    gliderlabs/registrator:latest \

    registry:2 \
    quiq/docker-registry-ui \

    google/cadvisor \

    sonatype/nexus3 \
    sonarqube:alpine \

    postgres:10.5-alpine \
    adminer \

    osixia/openldap \
    osixia/phpldapadmin \

    portainer/portainer \
    portainer/agent \

    selenium/hub \
    selenium/node-chrome \
    selenium/node-firefox \

    docker.elastic.co/elasticsearch/elasticsearch-oss:6.6.0 \
    docker.elastic.co/kibana/kibana-oss:6.6.0 \
    docker.elastic.co/logstash/logstash-oss:6.6.0 \
    docker.elastic.co/beats/metricbeat:6.6.0 \
    docker.elastic.co/beats/filebeat:6.6.0 \

    rabbitmq:3 \
    memcached:alpine \
    ansible/awx_web:latest \
    ansible/awx_task:latest \

    certbot/certbot \

    hashicorp/terraform \
    
    hello-world)

for i in "${images[@]}"
do
    { 
        echo "Download ${i}"
        docker pull "$i"
    } || { 
        echo "ReTry Download ${i}"
        sleep 5
        docker pull "$i"
    }

done