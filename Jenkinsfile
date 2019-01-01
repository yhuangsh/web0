pipeline {
  agent {
    kubernetes {
      label 'web0'
      yaml """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: dev-alpine-erlang-git
    image: yhuangsh/dev-alpine-erlang-git:latest
    tty: true
"""
    }
  }
  stages {
    stage('Pull') {
      steps {
        container('dev-alpine-erlang-git') {
          sh 'git clone https://github.com/yhuangsh/web0'
        }
      }
    }
    stage('Build') {
      steps {
        container('dev-alpine-erlang-git') {
          sh 'rebar3'
        }
      }
    }
  }
}