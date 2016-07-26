#!/bin/sh
set -eu

if [ $LDAP_SERVER == "configure-me"]
then
    echo "Variable named LDAP_SERVER is not set.
It must countain the address of your ldap server.
For example :

docker run -ti -p 10080:80  -e LDAP_SERVER= fusiondirectory"
    exit 127
fi

export LDAP_DOMAIN_DC="dc=$(echo ${SLDAP_DOMAIN} | sed  's/\./,dc=/g')"

envsubst < /fusiondirectory.conf > /etc/fusiondirectory/fusiondirectory.conf

# Don't quit the next loop on cat error
set +e

echo "Wait tcp connection to ldap server"

while [ /usr/bin/curl -v -k  ldap://${SLDAP_DOMAIN}:389/${LDAP_DOMAIN_DC} ]; do
    sleep 1
done

# Reactivate crash on error
set -e

if [ ! -e "/etc/fusiondirectory/fusionready" ]; then

    yes Yes | fusiondirectory-setup --check-config
    echo "Inject some Fusion directory configurations like :
- Fusion directory administrator account
- Various Fusion directory defaut configurations
- Group OU : ou=groups=${SLDAP_DOMAIN}
- Users OU : ou=peoples=${SLDAP_DOMAIN}"
    fusiondirectory-setup --yes --check-ldap << EOF
admin
$FUSIONDIRECTORY_PASSWORD
$FUSIONDIRECTORY_PASSWORD
EOF
    touch /etc/fusiondirectory/fusionready
fi

echo "Start Apache/php to reach Fusiondirectory virtualhost on :
http://<url>/fusiondirectory"
gosu www-data sh -c ". /etc/apache2/envvars && /usr/sbin/apache2 -D FOREGROUND"
