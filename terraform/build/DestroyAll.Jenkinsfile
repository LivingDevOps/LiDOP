def jobs() {
    List<String> workspaces = new ArrayList<String>()
    def data = new groovy.json.JsonSlurper()
        .parse(new URL("http://${env.IPADDRESS}:8500/v1/kv/terraform?keys"))
    for(item in data){
        workspaces.add(item.split(':')[1])
    } 
    return workspaces
}

def parallelStagesMap = jobs().collectEntries {
    ["${it}" : generateStage(it)]
}

def generateStage(job) {
  return {
    stage("Delete: ${job}") {
      echo "This is ${job}."
        build job: 'LiDOPCloud/Destroy_Stack', parameters: [string(name: 'Name', value: "${job}"), string(name: 'Password', value: 'Password'), credentials(description: 'AWS Key', name: 'AWS_Key', value: "${params.AWS_Key}"), credentials(description: 'AWS Secret', name: 'AWS_Secret', value: "${params.AWS_Secret}")]
    }
  }
}

pipeline {
  agent {
    label 'master'
  }

  parameters {
    credentials(name: 'AWS_Key', description: 'AWS_Key', defaultValue: '', credentialType: "org.jenkinsci.plugins.plaincredentials.impl.StringCredentialsImpl", required: true )
    credentials(name: 'AWS_Secret', description: 'AWS_Secret', defaultValue: '', credentialType: "org.jenkinsci.plugins.plaincredentials.impl.StringCredentialsImpl", required: true )  
  }

  stages {
    stage('parallel stage') {
      steps {
        script {
          parallel parallelStagesMap
        }
      }
    }

  }
}