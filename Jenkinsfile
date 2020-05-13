pipeline {
  environment {
    registry = "danman28/howdy-site"
    registryCredential = 'dockerhub'
    dockerImage = ''
  }
  agent any
  stages {
 
    stage('Build Image') {
      steps{
        script {
            echo 'Registry Green'
            dockerImage = docker.build registry + ":$BUILD_NUMBER"
        }
      }
    }
    stage('Push Image') {
      steps{
        script {
            docker.withRegistry( '', registryCredential ) {
              dockerImage.push()
              sh "docker rmi danman28/howdy-site:" + "$BUILD_NUMBER"
          }
        }
      }
    }
    stage('Set current kubectl context') {
      steps {
            withAWS(region: 'us-east-2', credentials: 'aws-access') {
              sh 'kubectl config view'
              sh 'kubectl config use-context arn:aws:eks:us-east-2:204204951085:cluster/kubernetes-cluster'
        }
      }
    }
    stage('Deploy container') {
      steps {
            withAWS(region: 'us-east-2', credentials: 'aws-access') {
              sh 'kubectl apply -f flask-deployment.yaml'
              sh 'kubectl apply -f flask-service.json'
              sh 'kubectl set image deployments/site-deployment site-image=danman28/howdy-site' + ":$BUILD_NUMBER"
              sh 'kubectl get services -o wide'
              }
            } 
      }
  }
}