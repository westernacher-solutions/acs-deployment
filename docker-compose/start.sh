export HOST_IP=$(ifconfig | grep -E "([0-9]{1,3}\.){3}[0-9]{1,3}" | grep -v 127.0.0.1 | awk '{ print $2 }' | cut -f2 -d: | head -n1)
export AUTH_SERVER_URL="http://${HOST_IP}:8081/auth"

export APP_CONFIG_AUTH_TYPE="OAUTH"
export APP_CONFIG_OAUTH2_HOST="http://${HOST_IP}:8081/auth/realms/alfresco"
export APP_CONFIG_OAUTH2_CLIENTID="alfresco"
export APP_CONFIG_OAUTH2_REDIRECT_SILENT_IFRAME_URI="./assets/silent-refresh.html"
export APP_CONFIG_OAUTH2_REDIRECT_LOGIN="/workspace"
export APP_CONFIG_OAUTH2_REDIRECT_LOGOUT="/workspace/logout"

docker-compose -f docker-compose.yml up