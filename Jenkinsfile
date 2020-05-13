pipeline {
  environment {
    registryGreen = "danman28/flask-app-green"
    registryBlue = "danman28/flask-app-blue"
    registryCredential = 'dockerhub'
    dockerImage = ''
  }
  agent any
  stages {
    // stage('is build even') {
    //   steps {
    //     script {
    //       if (env.BUILD_NUMBER.toBigInteger().mod( 2 ) == 0 ) {
    //         echo 'Even Build'
    //         }else {
    //           echo 'Odd Build'
    //         }
    //     }
    //   }
    // }

    stage('Build Image') {
      steps{
        script {
          // if (env.BUILD_NUMBER.toBigInteger().mod( 2 ) == 0 ) {
          //   echo 'Registry Blue'
          //  dockerImage = docker.build registryBlue + ":latest"

          // }else {
            echo 'Registry Green'
            dockerImage = docker.build registryGreen + ":latest"
          //}
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
    stage("add AWS config") {
      steps {
        withAWS(region: 'us-east-2', credentials: 'aws-access') {
          sh 'aws eks --region us-east-2 update-kubeconfig --name kubernetes-cluster'
        }
      }
    }
    stage('Deploy replication controllers') {
      steps {
        withAWS(region: 'us-east-2', credentials: 'aws-access') {
          sh 'kubectl config view'
          sh 'kubectl config use-context arn:aws:eks:us-east-2:204204951085:cluster/kubernetes-cluster'
          sh 'kubectl apply -f flask-controller.json'
          sh 'kubectl apply -f flask-service.json'
          sh 'kubectl create service nodeport hello-world --tcp=80:80'

          // sh 'kubectl apply -f https://raw.githubusercontent.com/kubernetes/examples/master/guestbook-go/redis-master-controller.json'
          // sh 'kubectl apply -f https://raw.githubusercontent.com/kubernetes/examples/master/guestbook-go/redis-master-service.json'
          // sh 'kubectl apply -f https://raw.githubusercontent.com/kubernetes/examples/master/guestbook-go/redis-slave-controller.json'
          // sh 'kubectl apply -f https://raw.githubusercontent.com/kubernetes/examples/master/guestbook-go/redis-slave-service.json'
          // sh 'kubectl apply -f https://raw.githubusercontent.com/kubernetes/examples/master/guestbook-go/guestbook-controller.json'
          // sh 'kubectl apply -f https://raw.githubusercontent.com/kubernetes/examples/master/guestbook-go/guestbook-service.json'
          sh 'kubectl get services -o wide'
        }
      }
    }
     
    // stage('Remove Unused docker image') {
    //   steps{
    //     sh "docker rmi $registry:$BUILD_NUMBER" 
    //   }
    // }
  }
}