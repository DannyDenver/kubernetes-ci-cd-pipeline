pipeline {
  environment {
    registry = "danman28/jenkins-pipeline"
    registryCredential = 'dockerhub'
    dockerImage = ''
  }
  agent any
  stages {
    stage('Cloning Git') {
      steps {
        git 'https://github.com/DannyDenver/kubernetes-ci-cd-pipeline'
      }
    }
    stage('Building image') {
      steps{
        script {
          dockerImage = docker.build registry + ":$BUILD_NUMBER"
        }
      }
    }
    stage('Push Image') {
      steps{
        script {
          docker.withRegistry( '', registryCredential ) {
            dockerImage.push()
          }
        }
      }
    }
    stage('set current kubectl context') {
        steps {
            withAWS(region:'us-east-2', credentials: 'aws-access') {
                sh 'kubectl config use-context arn:aws:eks:us-east-2:204204951085:cluster/EKS-2QZXVNAP'
            }
        }
    }
    stage('Deploy container') {
        kubectl apply -f ./new-image-controller.json
    }

    stage('Remove Unused docker image') {
      steps{
        sh "docker rmi $registry:$BUILD_NUMBER"
      }
    }
  }
}