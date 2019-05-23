# helm repo add alfresco-stable https://kubernetes-charts.alfresco.com/stable
# https://github.com/helm/helm/issues/2998
# (cd helm/alfresco-content-services/ && helm dependency update)
# docker build -t registry.gitlab.westernacher.com/torsten.werner/acs-deployment/alfresco-installer:0.1 .
# docker push registry.gitlab.westernacher.com/torsten.werner/acs-deployment/alfresco-installer:0.1

# docker tag registry.gitlab.westernacher.com/torsten.werner/acs-deployment/alfresco-installer:0.1 westernacher-docker.artifactory.test.bnotk.net/com.westernacher.alfresco-installer:0.1
# docker push westernacher-docker.artifactory.test.bnotk.net/com.westernacher.alfresco-installer:0.1

FROM gcr.io/kubernetes-helm/tiller:canary
USER root
RUN mkdir /alfresco-installer
WORKDIR /alfresco-installer
ADD . ./
ENTRYPOINT ["/alfresco-installer/alfresco-installer.sh"]
RUN /helm init --client-only && \
    /helm repo add alfresco-stable https://kubernetes-charts.alfresco.com/stable

