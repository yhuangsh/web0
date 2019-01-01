pipeline {
    agent {
        docker {
            image 'yhuangsh/dev-alpine-erlang-git:latest'
            args '-p 7000:7000'
        }
    }
    stages {
        stage("Pull") {
            steps {
                sh 'git clone https://github.com/yhuangsh/web0'
            }
        }
    }
}