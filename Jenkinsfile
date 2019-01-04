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
    stage('Pull') {
      steps {
        sh 'git clone https://github.com/yhuangsh/web0'
      }
    }
    stage('Build') {
      steps {
        sh 'rebar3 compile'
      }
    }
    stage('Tag') {
      steps {
        withCredentials([usernamePassword(credentialsId: '76b47592-7939-449d-a880-12ec200fcf84', passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
          sh("git tag -a b1 -m 'successful dev build tagged by Jenkins'")
          sh('git push https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/yhuangsh/web0 --tags')
        }
      }
    }
  }
}