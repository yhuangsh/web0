node {
    environment {
        DOCKER_HOST = 'tcp://172.17.94.121:2375'
        DEV_IMAGE = 'yhuangsh/dev-alpine-erlang-git:latest'
    }
    
    checkout scm

    docker.withServer('tcp://172.17.94.121:2375') {
        docker.image('yhuangsh/dev-alpine-erlang-git:latest').withRun('-p 7000:7000') {
            sh 'git clone https://github.com/yhuangsh/web0'
        }
    }
}