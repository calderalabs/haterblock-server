pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        sh './bin/ci/build.sh'
      }
    }
    stage('Test') {
      steps {
        sh 'mix test'
        sh 'docker-compose down'
      }
    }
  }
}