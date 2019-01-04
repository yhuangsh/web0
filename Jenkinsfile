pipeline {
  agent {
    kubernetes {
      label 'web-dev-builder'
      yaml """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: dev-alpine-erlang
    image: yhuangsh/dev-alpine-erlang:latest
    tty: true
"""
    }
  }
  stages {
    stage('Local Pull') {
      steps {
        sh 'git clone https://github.com/yhuangsh/web0'
      }
    }
    stage('Pull') {
      steps {
        container('dev-alpine-erlang') {
          sh 'git clone https://github.com/yhuangsh/web0'
        }
      }
    }
    stage('Build') {
      steps {
        container('dev-alpine-erlang') {
          sh 'rebar3 compile'
        }
      }
    }
  }
}