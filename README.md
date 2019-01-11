# The Kubernetes/Erlang Experiment

## web0 v0.1.0

### What's Working
- A skeleton of an Erlang application cluster running on top of a Kubernetes cluster
- `/web0` shows the node info of the node handling the request and all other nodes in the Erlang cluster
- `/web0/dumpreq` shows the dump of important HTTP request info passed on from Cowboy web server

### Things Learned
- Use vm.args.src to pass -name and -setcookie parameters to Erlang VM. The file vm.args.src may use environment variables
- Use docker --net, --ip, --add-host --hostname to mimic the actual Kubernetes environemnt for development, having three nodes running on the same development machine without changing the code
- Use Kubernetes Jenkins plugin for CI/CD builds: complete cycle of pull, build, test, release, tag, make and push the built docker image
- Set up webhooks in Github to trigger automatic Jenkins builds  