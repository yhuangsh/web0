#!/bin/sh

docker run \
    --name web0.dev \
    --hostname web0.dev \
    -v `pwd`:/project \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -p 7000:7000 \
    --rm \
    -it \
    yhuangsh/dev-alpine-erlang:latest