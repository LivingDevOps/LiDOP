#!groovy

pipeline {
  agent {
    label 'did'
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
    BuildName = "Create-Stack-${params.Name}.${BUILD_NUMBER}"
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
        sh "docker run --rm -w /work -v ${WORKSPACE}/:/work hashicorp/terraform init -backend-config=address=${env.IPADDRESS}:8500 /work/aws"
      }
    }

    stage("Terraform select workspace") {
      steps {
       sh "docker run --rm -w /work -v ${WORKSPACE}/:/work hashicorp/terraform workspace select ${params.Name} /work/aws"
      }
    }

    stage("Terraform plan") {
      steps {
	      withCredentials([string(credentialsId: "${params.AWS_Secret}", variable: 'AWS_SECRET'), string(credentialsId: "${params.AWS_Key}", variable: 'AWS_KEY')]) {
	        sh "docker run --rm -w /work -v ${WORKSPACE}/:/work hashicorp/terraform plan -var access_key=${AWS_Key} -var enabled=0 -var secret_key=${AWS_Secret} -var user_name=${params.Name} -var password=${params.Password} /work/aws"
        }      
      }
    }

    stage("Terraform destroy") {
      steps {
    	  withCredentials([string(credentialsId: "${params.AWS_Secret}", variable: 'AWS_SECRET'), string(credentialsId: "${params.AWS_Key}", variable: 'AWS_KEY')]) {
	        sh "docker run --rm -w /work -v ${WORKSPACE}/:/work hashicorp/terraform destroy -auto-approve -var access_key=${AWS_Key} -var enabled=0 -var secret_key=${AWS_Secret} -var user_name=${params.Name} -var password=${params.Password} /work/aws"
        }      
      }
    }

    stage("Terraform delete workspace") {
      steps {
       sh "docker run --rm -w /work -v ${WORKSPACE}/:/work hashicorp/terraform workspace select default /work/aws"
       sh "docker run --rm -w /work -v ${WORKSPACE}/:/work hashicorp/terraform workspace delete ${params.Name} /work/aws"
      }
    }

  }
}
