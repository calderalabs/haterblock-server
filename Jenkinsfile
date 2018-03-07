pipeline {
  agent any
  stages {
    stage('Docker up') {
      steps {
        sh 'docker-compose up -d'
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