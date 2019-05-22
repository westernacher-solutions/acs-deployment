# Demo-Installation von Alfresco 6.1.0 in Kubernetes

- Ticket: https://jira.westernacher.com/browse/BNOTKRM-1476

**Aufgabe:** Bereitstellung der Alfresco-Docker-Images und einer Installationsmöglichkeit in Kubernetes

**Hinweis:** Es wurden die Enterprise-Images in das BNotK-Artifactory hochgeladen.
Dabei ist aufgefallen, dass die vom Artifactory verwendeten SSL-Zertifikate von einem Standard-Docker nicht akzeptiert werden.
Das kann zu Problemen bei der Installation führen.

## Bereitstellung des Kubernetes-Cluster

Zum Test haben wir die Installation auf einem Ubuntu 18.04 System mit 16 GB RAM und der Software MicroK8s durchgeführt.
Der Cluster benötigt nach Installation unter 7 GB RAM, aber während der Installation wird vorübergehend mehr Speicher benötigt.
Die Installation sollte grundsätzlich in jedem Kubernetes-Cluster möglich sein.
Damit unser Vorgehen nachvollziehbar wird und auch die benötigten Komponenten dokumentiert sind, wird das Vorgehen an
dieser Stelle mittels MicroK8s beschrieben.

Die folgenden Kommandos müssen ausgeführt werden. Eine detailliertere Dokumentation gibt es unter https://microk8s.io/ .
Der metrics-server ist dabei optional, aber durchaus zu empfehlen, damit man die Ressourcenauslastung prüfen kann.

    snap install microk8s --classic
    snap alias microk8s.kubectl kubectl
    microk8s.enable dns
    microk8s.enable ingress
    microk8s.enable storage
    microk8s.enable metrics-server

Für die folgenden Schritte wird die externe IP-Adresse des Servers benötigt.
Diese sollte nun ermittelt und notiert werden.

## Installation der Alfresco-Komponenten

Zunächst sind die Credentials für die Docker-Registry als Secret zu hinterlegen.
Dies geschieht hier im aktuellen Namespace z.B. "default".
Die Werte für _login_ und _password_ müssen natürlich ersetzt werden.

    kubectl create secret docker-registry westernacher-docker \
        --docker-server=westernacher-docker.artifactory.test.bnotk.net \
        --docker-username=login --docker-password=password

Danach wird der ServiceAccount _default_ gepatched:

    kubectl patch serviceaccount default -p '{"imagePullSecrets": [{"name": "westernacher-docker"}]}'

Nun ist der Installer auszuführen. Die IP-Adresse bei externalHost muss durch die o.g. Adresse ersetzt werden.
Falls es neuere Versionen des Installers gibt, muss das Tag beim Image ggf. aktualisiert werden.

    kubectl run -it --rm alfresco-installer \
        --image westernacher-docker.artifactory.test.bnotk.net/com.westernacher.alfresco-installer:0.1 \
        --restart Never -- --set externalProtocol="https" --set externalHost="95.217.1.233" --set externalPort="443" \
        --set imageprefix="westernacher-docker.artifactory.test.bnotk.net/com.westernacher."

Sobald der Installer sich beendet hat, kann man mit folgendem Kommando den Status der Pods bzw. Container prüfen:

    kubectl get pods --watch
    
Nachdem alle Container gestartet sind, sind die Anwendungen unter folgenden URLs zu erreichen.
Die IP-Adresse ist natürlich wieder anzupassen.

- Share: https://95.217.1.233:443/share
- Content: https://95.217.1.233:443/alfresco

Die Password für den Benutzer _admin_ lautet _admin_.
