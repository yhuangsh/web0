#!/bin/sh
HOSTNAME=$(hostname -f) /deploy/web0/bin/web0 foreground -mnesia dir '"/deploy/data/web0"'