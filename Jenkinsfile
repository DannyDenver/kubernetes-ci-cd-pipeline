pipeline {
  environment {
    registry = "danman28/howdy-site:latest"
    registryCredential = 'dockerhub'
    dockerImage = ''
  }
  agent any
  stages {
 
    stage('Build Image') {
      steps{
        script {
            echo 'Registry Green'
            dockerImage = docker.build registry
        }
      }
    }
    stage('Push Image') {
      steps{
        script {
            docker.withRegistry( '', registryCredential ) {
              dockerImage.push()
              sh "docker rmi danman28/howdy-site:latest" 
          }
        }
      }
    }
    // stage("add AWS config") {
    //   steps {
    //     withAWS(region: 'us-east-2', credentials: 'aws-access') {
    //       sh 'aws eks --region us-east-2 update-kubeconfig --name kubernetes-cluster'
    //     }
    //   }
    // }

    stage('Deploy replication controllers') {
      steps {
            withAWS(region: 'us-east-2', credentials: 'aws-access') {
              sh 'kubectl config view'
              sh 'kubectl config use-context arn:aws:eks:us-east-2:204204951085:cluster/kubernetes-cluster'
              sh 'kubectl apply -f flask-deployment.yaml'
              sleep(time:20,unit:"SECONDS")
              sh 'kubectl apply -f flask-service.json'
              // sh 'kubectl set image deployments/flask-app flask-app=danman28/howdy-site:latest'
              sh 'kubectl get services -o wide'
              }
            } 
          }
  }
}