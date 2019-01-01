pipeline {
    agent {
        docker {
            image 'yhuangsh/dev-alpine-erlang-git:latest'
            args '-H tcp://172.17.94.121:2375 -p 7000:7000'
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