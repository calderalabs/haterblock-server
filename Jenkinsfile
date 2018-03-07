pipeline {
  agent {
    docker {
      image 'elixir'
    }
    
  }
  stages {
    stage('Install') {
      steps {
        sh './bin/ci/install.sh'
      }
    }
    stage('Build') {
      steps {
        sh './bin/ci/build.sh'
      }
    }
  }
}