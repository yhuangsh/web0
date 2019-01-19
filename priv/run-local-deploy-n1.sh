#!/bin/sh
docker run \
    --rm \
    --net dev-net \
    --name web0-1 \
    --ip 172.28.0.3 \
    --hostname web0-1.web0.default.svc.cluster.local \
    --add-host web0-0.web0.default.svc.cluster.local:172.28.0.2 \
    --add-host web0-1.web0.default.svc.cluster.local:172.28.0.3 \
    --add-host web0-2.web0.default.svc.cluster.local:172.28.0.4 \
    --add-host api0:172.28.0.13 \
    -p 7001:7000 \
    -it yhuangsh/web0-dev-build:latest \
    /deploy/web0/bin/web0 console