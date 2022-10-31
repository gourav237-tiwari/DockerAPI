pipeline
{ agent { docker { image 'mven:3.3.3'
} }
stages {

stage('log version info') {
steps {
sh 'mvn --version'
sh 'mvn clean install'
}
}
stage('Docker Build') {
    	agent any
      steps {
      	sh 'docker build -t DockerAPI .'
      }
    }
}
}