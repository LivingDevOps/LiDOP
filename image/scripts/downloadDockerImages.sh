#!/bin/bash -eux

echo "##########################################"
echo "Download Docker Images"
echo "##########################################"
images=(ubuntu:latest \
    alpine:latest \
    maven:alpine \
    node:alpine \
    tomcat:alpine \

    livingdevops/lidop.nginx \
    livingdevops/lidop.jenkins \
    livingdevops/lidop.backup \
    livingdevops/lidop.gitbucket \
    livingdevops/lidop.serverspec \
    livingdevops/lidop.sonarqube \
    livingdevops/lidop.sonarqube_scanner \

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

    jenkins/ssh-slave \

    portainer/portainer \
    portainer/agent \


    selenium/hub \
    selenium/node-chrome \
    selenium/node-firefox \

    docker.elastic.co/elasticsearch/elasticsearch-oss:6.3.0 \
    docker.elastic.co/kibana/kibana-oss:6.3.0 \
    docker.elastic.co/logstash/logstash-oss:6.3.0 \
    docker.elastic.co/beats/metricbeat:6.3.0 \
    docker.elastic.co/beats/filebeat:6.3.0 \

    rabbitmq:3 \
    memcached:alpine \
    ansible/awx_web:latest \
    ansible/awx_task:latest \

    certbot/certbot \
    
    hello-world)

for i in "${images[@]}"
do
    echo "Download ${i}"
    docker pull $i
done