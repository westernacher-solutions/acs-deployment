#!/bin/sh

set -x
PATH=$PATH:/
helm init --canary-image
sleep 8
cd helm
helm install alfresco-content-services --set alfresco-infrastructure.nginx-ingress.enabled=false "$@"
#helm reset --force
