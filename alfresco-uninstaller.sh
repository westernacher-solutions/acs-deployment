#!/bin/sh

set -x
PATH=$PATH:/
tiller &
sleep 1
cd helm
HELM_HOST=localhost:44134 helm delete --purge demo "$@"
killall tiller
