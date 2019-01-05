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
        sh 'hostname'
        sh 'pwd'
        sh 'ls -l'
        // git doesn't have to run within the container, seems Jenkins is using the image's WORDDIR as its workspace
        // We had done two git clone, one outside, one inside the container, the second clone will complain the project
        // had been there. 
        // The git ran should the git from the Jenksin image, not the image from our dev container image
        sh 'git clone https://github.com/yhuangsh/web0'
      }
    }
    stage('Build') {
      steps {
        // rebar3 had to run within the container because it's not included in the Jenkins image
        container('dev-alpine-erlang') {
          sh 'hostname'
          sh 'pwd'
          sh 'ls -l'
          sh 'rebar3 compile'
        }
      }
    }
    stage('Test') {
      steps {
        sh 'echo "Nothing, placeholder now"'
      }
    }
    stage('Tag') {
      steps {
        sh 'hostname'
        sh 'pwd'
        sh 'ls -l'
        // Credit: https://github.com/jenkinsci/pipeline-examples/blob/master/pipeline-examples/push-git-repo/pushGitRepo.groovy 
        // This keeps the github username/password, or SSH key within the Jenkins configuration, no having to be stored in 
        // the dev container image
        withCredentials([usernamePassword(credentialsId: '76b47592-7939-449d-a880-12ec200fcf84', passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
          sh 'git tag -a b${BUILD_NUMBER} -m "successful dev build tagged by Jenkins"'
          sh 'git push https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/yhuangsh/web0 --tags'
        }
      }
    }
    stage('Release, make and push dev build image') {
      environment {
          DOCKER_HOST='tcp://172.17.94.121:2375'
          WEB0_IMAGE='yhuangsh/web0-dev-build'
          WEB0_IMAGE_TAG='latest'
      }
      steps {  
        container('dev-alpine-erlang') {
          sh 'hostname'
          sh 'pwd'
          sh 'ls -l'
          sh 'rebar3 release'
          sh 'docker build -f priv/Dockfile.dev-build -t ${WEB0_IMAGE}:${WEB0_IMAGE_TAG} .'
          sh 'docker push ${WEB0_IMAGE}:${WEB0_IMAGE_TAG}'
        }
      }
    }
  }
}