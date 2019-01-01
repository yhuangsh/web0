#!/bin/sh

docker run \
    --name web0.dev \
    --hostname web0.dev \
    -v `pwd`:/project \
    -p 7000:7000 \
    --rm \
    -it \
    yhuangsh/erlang-alpine-dev:v1