#!/bin/sh

docker run \
    --name web0.dev.local \
    --hostname web0.dev.local \
    -v `pwd`:/project \
    -p 7000:7000 \
    --rm \
    -it \
    yhuangsh/dev-alpine-erlang:latest