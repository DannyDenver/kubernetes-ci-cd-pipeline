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
            dockerImage = docker.build registry + ":latest"
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
    stage("add AWS config") {
      steps {
        withAWS(region: 'us-east-2', credentials: 'aws-access') {
          sh 'aws eks --region us-east-2 update-kubeconfig --name kubernetes-cluster'
        }
      }
    }

    stage('Deploy replication controllers') {
      steps {
        script {
          if(env.BUILD_NUMBER.toBigInteger() > 1) {
            stage('setup load balancer and deployment') {
              withAWS(region: 'us-east-2', credentials: 'aws-access') {
                sh 'kubectl config view'
                sh 'kubectl config use-context arn:aws:eks:us-east-2:204204951085:cluster/kubernetes-cluster'
                sh 'kubectl set image deployments/flask-app flask-app=danman28:flask-app-green:latest'
                sh 'kubectl get services -o wide'
              }
          }  
        } else {
            stage("setup load balancer and deployment") {
              withAWS(region: 'us-east-2', credentials: 'aws-access') {
              sh 'kubectl config view'
              sh 'kubectl config use-context arn:aws:eks:us-east-2:204204951085:cluster/kubernetes-cluster'
              sh 'kubectl apply -f flask-deployment.yaml'
              sh 'kubectl apply -f flask-service.json'
              sh 'kubectl get services -o wide'
              }
            } 
          }
        }
      }
    }
    stage('Remove Unused docker image') {
      steps{
        sh "docker rmi $registry:$BUILD_NUMBER" 
      }
    }
  }
}