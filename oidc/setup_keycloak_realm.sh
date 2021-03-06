#!/usr/bin/env bash
# Start up keycloak and config for new user & client
#
set -euo pipefail

source /opt/jboss/config.sh

readonly KC_PATH=/opt/jboss/keycloak/bin

echo "# Connecting to keycloak..."
${KC_PATH}/kcadm.sh config credentials --server http://localhost:8080/auth --realm master --user ${ADMIN} --password ${ADMINPWD}

echo "# Creating realm.."
${KC_PATH}/kcadm.sh create realms -s realm=${REALM} -s enabled=true

echo "# Creating login client.."
LOGIN_ID=$(${KC_PATH}/kcadm.sh create clients -r ${REALM} -s clientId=${CLIENT_LOGIN_ID} \
                               -s enabled=true -s 'redirectUris=["*"]' -s directAccessGrantsEnabled=true \
                               -s secret=${CLIENT_LOGIN_SECRET} \
                               -i)


echo "# Login client ID follows..."
echo $LOGIN_ID

echo "# Login client config follows..."
${KC_PATH}/kcadm.sh get clients/${LOGIN_ID}/installation/providers/keycloak-oidc-keycloak-json -r ${REALM}

echo "# Creating user1"
${KC_PATH}/add-user-keycloak.sh -r ${REALM} -u ${USER1} -p ${USER1PWD}

echo "# Creating user2"
${KC_PATH}/add-user-keycloak.sh -r ${REALM} -u ${USER2} -p ${USER2PWD}

echo "# Now restart"