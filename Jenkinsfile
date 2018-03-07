pipeline {
  agent {
    docker {
      image 'elixir'
    }
    
  }
  stages {
    stage('Build') {
      steps {
        sh 'mix deps.get'
      }
    }
  }
}