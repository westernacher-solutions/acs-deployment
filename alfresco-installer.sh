#!/bin/sh

set -x
PATH=$PATH:/
tiller &
sleep 1
cd helm
HELM_HOST=localhost:44134 helm install alfresco-content-services --name demo "$@"
killall tiller
