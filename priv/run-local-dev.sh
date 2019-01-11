#!/bin/sh

docker run \
    --rm \
    --name app \
    --hostname "web0-2.web0.default.svc.cluster.local" \
    -v `pwd`:/project \
    -p 7000:7000 \
    -it \
    yhuangsh/dev-alpine-erlang:latest