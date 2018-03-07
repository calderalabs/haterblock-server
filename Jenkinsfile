pipeline {
  agent {
    docker {
      image 'elixir'
    }
    
  }
  stages {
    stage('Build') {
      steps {
        sh 'mix local.hex'
        sh 'mix archive.install https://github.com/phoenixframework/archives/raw/master/phx_new.ez'
        sh 'mix deps.get'
      }
    }
  }
}