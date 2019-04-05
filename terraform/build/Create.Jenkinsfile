#!groovy

pipeline {
  agent {
    label 'default'
  }
  
  options {
    buildDiscarder(logRotator(numToKeepStr: '100', daysToKeepStr: '365'))
  }

  parameters {
    string(name: 'Name', defaultValue: 'Name', description: 'Name of LiDOP')
    string(name: 'User', defaultValue: 'lidop', description: 'Username')
    string(name: 'Password', defaultValue: 'lidop', description: 'Password')
    credentials(name: 'AWS_Key', description: 'AWS_Key', defaultValue: '', credentialType: "org.jenkinsci.plugins.plaincredentials.impl.StringCredentialsImpl", required: true )
    credentials(name: 'AWS_Secret', description: 'AWS_Secret', defaultValue: '', credentialType: "org.jenkinsci.plugins.plaincredentials.impl.StringCredentialsImpl", required: true )  
  }

  environment {
    BuildName = "Create-Stack.${BUILD_NUMBER}"
  }

  stages {
    stage('Build Number') {
      steps {
        script {
          currentBuild.displayName = "${BuildName}"
        }
      }
    }

    stage("Terraform init") {
      steps {
        sh 'ln -sf ./../terraform.backend.consul.tf ./aws/terraform.tf'
        sh "terraform init -backend-config=address=${env.IPADDRESS}:8500 ./aws"
      }
    }

    stage("Terraform workspace") {
      steps {
       sh "terraform workspace new ${params.Name} ./aws"
      }
    }

    stage("Terraform plan") {
      steps {
	      withCredentials([string(credentialsId: "${params.AWS_Secret}", variable: 'AWS_SECRET'), string(credentialsId: "${params.AWS_Key}", variable: 'AWS_KEY')]) {
	        sh "terraform plan -var access_key=${AWS_Key} -var enabled=0 -var secret_key=${AWS_Secret} -var user_name=${params.Name} -var password=${params.Password} ./aws"
        }      
      }
    }

    stage("Terraform apply") {
      steps {
	      withCredentials([string(credentialsId: "${params.AWS_Secret}", variable: 'AWS_SECRET'), string(credentialsId: "${params.AWS_Key}", variable: 'AWS_KEY')]) {
	        sh "terraform apply -auto-approve -var access_key=${AWS_Key} -var enabled=0 -var secret_key=${AWS_Secret} -var user_name=${params.Name} -var password=${params.Password} ./aws"
        }      
      }
    }

  }
}
