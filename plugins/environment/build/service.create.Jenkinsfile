#!groovy

pipeline {
  agent {
    label 'docker'
  }

  parameters {
        string(name: 'docker_image_version', defaultValue: 'latest', description: 'Which image version should be used.')
        choice(choices: 'cadvisor\nnexus\nsonarqube\ntomcat\nelk\nselenium\nawx\n', description: 'Which Service?', name: 'service')
  }
  
  options {
    buildDiscarder(logRotator(numToKeepStr: '100', daysToKeepStr: '365'))
  }

  environment {
    BuildName = "Create_Service_${params.service}.${BUILD_NUMBER}"
  }

  stages {
    stage('Build Number') {
      steps {
        script {
          currentBuild.displayName = "${BuildName}"
          currentBuild.description = "Startup ${params.service}."
        }
      }
    }

    stage("Startup Service") {
      steps {
        dir("./${params.service}"){
          withCredentials([usernamePassword(credentialsId: 'lidop', passwordVariable: 'root_password', usernameVariable: 'root_user')]) {
            withCredentials([usernamePassword(credentialsId: 'lidop_secret_password', passwordVariable: 'secret_password', usernameVariable: 'secret_user')]) {
              sh "ansible-playbook service.yml -v -e \"docker_image_version=${params.docker_image_version} ipaddress=${env.IPADDRESS} state=present root_user=${root_user} root_password=${root_password} secret_password=${secret_password}\""
            }
          }
        }
      }
    }

  }
}