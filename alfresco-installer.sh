#!/bin/sh

/tiller &
sleep 1
cd helm
/helm install alfresco-content-services --set alfresco-infrastructure.nginx-ingress.enabled=false "$@"
killall tiller
