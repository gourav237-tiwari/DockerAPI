#!groovy

pipeline {
	agent none  stages {
  	
    stage('Docker Build') {
    	agent any
      steps {
      	sh 'sudo docker build -t dockerwebapi .'
      }
    }
    }
}