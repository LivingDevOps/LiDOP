#Example

```groovy
#!groovy
//@Library('utils@master') _
@Library('utils') _
pipeline {
  agent {
    label 'host'
  }

  stages {
    stage('Step 1') {
      steps {
        script {
            causes.setEnvironment()
            log.info("test")
            log.warning("test")
       }
      }
    }
    
    stage("Step 2"){
        steps{
            runOnHost{
                sh "echo ${env.user}"
            }       
        }
    }
  }
}
```
