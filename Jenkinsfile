node {
    environment {
        DOCKER_HOST = 'tcp://172.17.94.121:2375'
        DEV_IMAGE = 'yhuangsh/dev-alpine-erlang-git:latest'
    }
    
    checkout scm

    docker.withServer('${DOCKER_HOST}') {
        docker.image('${DEV_IMAGE}').withRun('-p 7000:7000') {
            sh 'git clone https://github.com/yhuangsh/web0'
        }
    }
}