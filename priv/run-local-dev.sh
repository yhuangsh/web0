#!/bin/sh
docker run \
    --rm \
    --net web0-net \
    --name web0-0 \
    --ip 172.28.0.2 \
    --hostname web0-0.web0.default.svc.cluster.local \
    -v `pwd`:/project \
    -p 7000:7000 \
    -it \
    yhuangsh/dev-alpine-erlang:latest