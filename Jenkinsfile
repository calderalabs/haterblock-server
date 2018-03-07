pipeline {
  agent any
  stages {
    stage('Docker up') {
      steps {
        sh './bin/ci/install_docker_compose.sh'
      }
    }
    stage('Build') {
      steps {
        sh './bin/ci/build.sh'
      }
    }
    stage('Test') {
      steps {
        sh 'mix test'
      }
    }
    stage('Docker down') {
      steps {
        sh 'docker-compose down'
      }
    }
  }
}