#!groovy

pipeline {
  agent {
    label 'docker'
  }

  parameters {
    choice(choices: 'cadvisor\nnexus\nsonarqube\ntomcat\nelk\nselenium\nawx\n', description: 'Which Service?', name: 'service')
  }
  
  options {
    buildDiscarder(logRotator(numToKeepStr: '100', daysToKeepStr: '365'))
  }

  environment {
    BuildName = "Destroy_Service_${params.service}.${BUILD_NUMBER}"
  }

  stages {
    stage('Build Number') {
      steps {
        script {
          currentBuild.displayName = "${BuildName}"
          currentBuild.description = "Destroy ${params.service}."
        }
      }
    }

    stage("Startup Service") {
      steps {
        dir("./${params.service}"){
          withCredentials([usernamePassword(credentialsId: 'lidop', passwordVariable: 'root_password', usernameVariable: 'root_user')]) {
            withCredentials([usernamePassword(credentialsId: 'lidop_secret_password', passwordVariable: 'secret_password', usernameVariable: 'secret_user')]) {
              sh "ansible-playbook service.yml -v -e \"ipaddress=${env.IPADDRESS} state=absent root_user=${root_user} root_password=${root_password} secret_password=${secret_password}\""
            }
          }
        }
      }
    }
    
  }
}