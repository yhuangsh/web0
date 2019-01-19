#!/bin/sh
docker run \
    --rm \
    --net dev-net \
    --name web0-0 \
    --ip 172.28.0.2 \
    --hostname web0-0.web0.default.svc.cluster.local \
    --add-host web0-0.web0.default.svc.cluster.local:172.28.0.2 \
    --add-host web0-1.web0.default.svc.cluster.local:172.28.0.3 \
    --add-host web0-2.web0.default.svc.cluster.local:172.28.0.4 \
    --add-host api0:172.28.0.12 \
    -v `pwd`:/project \
    -p 7000:7000 \
    -it \
    yhuangsh/dev-alpine-erlang:latest