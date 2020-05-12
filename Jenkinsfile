pipeline {
  environment {
    registryGreen = "danman28/flask-app-green"
    registryBlue = "danman28/flask-app-blue"
    registryCredential = 'dockerhub'
    dockerImage = ''
  }
  agent any
  stages {
    stage {
      steps {
        script {
              sh 'curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl'
  sh 'chmod +x ./kubectl && mv kubectl /usr/local/sbin'
        }
      }
    }

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
    stage("add AWS config") {
      steps {
        withAWS(region: 'us-east-2', credentials: 'aws-access') {
          sh 'aws eks --region us-east-2 update-kubeconfig --name EKS-64N10C7B'
        }
      }
    }

    stage('set current kubectl context') {
      steps {
        container('kubectl') {
              sh "kubectl config use-context arn:aws:eks:us-east-2:204204951085:cluster/EKS-64N10C7B"
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
    stage('Deploy to k8s') {
      steps {
        sh "chmod +x changeTag.sh"
        sh "./changeTag.sh ${env.BUILD_NUMBER}"
      }
    }


    stage('Deploy replication controllers') {
      steps {
        script {
          if (env.BUILD_NUMBER.toBigInteger() > 1) {
            sh "kubectl apply -f ./blue/blue-controller.json" 
            sh "kubectl apply -f ./green/green-controller.json"
          }else {
            sh "kubectl apply -f ./blue/blue-controller.json" 
            }
        }
      }
    }
     
    stage('Deploy load balancer servixe') {
      steps {
        sh "kubectl apply -f ./blue-green-service.json"
        }
    }

    stage('Remove Unused docker image') {
      steps{
        sh "docker rmi $registry:$BUILD_NUMBER" 
      }
    }
  }
}