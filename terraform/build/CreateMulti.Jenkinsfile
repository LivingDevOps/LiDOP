def jobs() {
    List<String> workspaces = new ArrayList<String>()
    Integer amounts = params.Amount as Integer
    for (int i=0; i < amounts; i++) {
      workspaces.add(params.Prefix + i)
    }
    return workspaces
}

def parallelStagesMap = jobs().collectEntries {
    ["${it}" : generateStage(it)]
}

def generateStage(job) {
  return {
    stage("Create: ${job}") {
      echo "This is ${job}."
        build job: 'LiDOPCloud/Create_Stack', parameters: [
          string(name: 'Name', value: "${job}"), 
          string(name: 'User', value: "${params.User}"), 
          string(name: 'Password', value: "${params.Password}"), 
          credentials(description: 'AWS Key', name: 'AWS_Key', value: "${params.AWS_Key}"), 
          credentials(description: 'AWS Secret', name: 'AWS_Secret', value: "${params.AWS_Secret}")
        ]
    }
  }
}

pipeline {
  agent {
    label 'master'
  }

  parameters {
    string(name: 'User', defaultValue: 'lidop', description: 'Username')
    string(name: 'Password', defaultValue: 'lidop', description: 'Password')
    string(name: 'Prefix', defaultValue: 'LiDOP_', description: 'Prefix')
    string(name: 'Amount', defaultValue: '1', description: 'Amount of Stacks')
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