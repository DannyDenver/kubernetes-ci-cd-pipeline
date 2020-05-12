pipeline {
  environment {
    registryGreen = "danman28/flask-app-green"
    registryBlue = "danman28/flask-app-blue"
    registryCredential = 'dockerhub'
    dockerImage = ''
  }
  agent any
  stages {
    stage('is build even') {
      steps {
        script {
          if (env.BUILD_NUMBER.toBigInteger().mod( 2 ) == 0 ) {
            echo 'Even Build'
            }else {
              echo 'Odd Build'
            }
        }
      }
    }
    stage('Building image') {
      steps{
        script {
          if (env.BUILD_NUMBER.toBigInteger().mod( 2 ) == 0 ) {
            echo 'Registry Blue'
           dockerImage = docker.build registryBlue + ":$BUILD_NUMBER"

          }else {
            echo 'Registry Green'
            dockerImage = docker.build registryGreen + ":$BUILD_NUMBER"
          }
        }
      }
    }
    stage('Push Image') {
      steps{
        script {
          if (env.BUILD_NUMBER.toBigInteger().mod( 2 ) == 0 ) {
            docker.withRegistry( '', registryCredential ) {
              dockerImage.push()
            }
          }else {
            docker.withRegistry( '', registryCredential ) {
              dockerImage.push()
            }
          }
        }
      }
    }
    stage('set current kubectl context') {
      steps {
          sh("kubectl config use-context arn:aws:eks:us-east-2:204204951085:cluster/EKS-64N10C7B")
        }
      }
    }

    stage('Deploy replication controllers') {
      steps {
        script {
          if (env.BUILD_NUMBER.toBigInteger() > 1) {
            sh("kubectl apply -f ./blue/blue-controller.json")
            sh("kubectl apply -f ./green/green-controller.json") 
          }else {
            sh("kubectl apply -f ./blue/blue-controller.json")
            }
        }
      }
    }
     
    stage('Deploy load balancer servixe') {
      steps {
        sh("kubectl apply -f ./blue-green-service.json")
        }
    }

    stage('Remove Unused docker image') {
      steps{
        sh "docker rmi $registry:$BUILD_NUMBER"
      }
    }
}