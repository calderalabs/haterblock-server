pipeline {
  agent {
    docker {
      image 'elixir'
    }
    
  }
  stages {
    stage('Build') {
      steps {
        sh './bin/ci/build.sh'
      }
    }
  }
}