#!/bin/bash
set -eu

# to manage backgroundjob during loop with sigint and sigterm
trap "exit 1" INT TERM EXIT

if (( "${ENABLE_SSL}" == 1 )); then
    a2enmod ssl
fi;

if [ $LDAP_SERVER == "configure-me"]
then
    echo "Variable named LDAP_SERVER is not set.
It must countain the address of your ldap server.
For example :

docker run -ti -p 10080:80  -e LDAP_SERVER=<ldap_server_url> fusiondirectory"
    exit 127
fi

export LDAP_DOMAIN_DC="dc=$(echo ${SLDAP_DOMAIN} | sed  's/\./,dc=/g')"

envsubst < /opt/fusiondirectory/fusiondirectory.conf > /etc/fusiondirectory/fusiondirectory.conf

# Don't quit the next loop on cat error
set +e

echo "Wait tcp connection to ldap server"
for i in {0..30}
do
    /usr/bin/curl --fail  --silent -k --connect-timeout 2 --output /dev/null  ldap://${LDAP_SERVER}:389/${LDAP_DOMAIN_DC} 2>/dev/null
    is_slapd_running=$?

    if (( "${is_slapd_running}" == 0 )); then
        break 1;
    else
        if (( "$i"  == 30 )); then
            echo "Ldap server dont respond after $i seconds"
            exit 1 ;
        fi;
    fi;
    sleep 1
    echo .
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

# Remove password as environment variable
export SLDAP_ROOTPASS=""
export FUSIONDIRECTORY_PASSWORD=""

echo "Start Apache/php to reach Fusiondirectory virtualhost on :
http://<url>/fusiondirectory"
gosu www-data sh -c ". /etc/apache2/envvars && /usr/sbin/apache2 -D FOREGROUND"
