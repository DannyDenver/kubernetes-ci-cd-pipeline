Deployment of a Docker container using Kubernetes and Jenkins for CI/CD
-----

### Introduction

This project demostrates my use of Docker, Kubernetes, Github and Jenkins to create a CI/CD pipeline to deploy Docker containers. 

### Overview

This project contains a jenkins pipeline. The steps in the pipeline can be found in the Jenkinsfile. 

Steps include: 
* Linting the Dockerfile for errors
* Building the image from the Dockerfile
* Pushing the image to Docker hub
* Setting current kubectl context to the EKS cluster
* Deploying the container using the deployment and load balancer service specs
* Linting the Dockerfile for errors

### Jenkins

The Jenkins pipeline is run up on a Ubuntu 18.04 LTS amd64 EC2 instance. The Java JDK, Jenkins, eksctl and kubectl were installed on the instance: https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html

Credentials for Github, AWS and Dockerhub were needed to create the pipeline.

Plugins Installed: BlueOcean, Github plugin, Kubernetes CLI Plugin, Pipeline: AWS Steps

Site, if still up:
http://a74f27ee05cc241cfa14a07d1c3b3558-1313406416.us-east-2.elb.amazonaws.com:3000/