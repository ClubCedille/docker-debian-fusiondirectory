#!/bin/bash
set -eu

LDAP_DOMAIN_DC1=`echo $SLDAP_DOMAIN|cut -d. -f1`
LDAP_DOMAIN_DC2=`echo $SLDAP_DOMAIN|cut -d. -f2`
LDAP_DOMAIN_DC3=`echo $SLDAP_DOMAIN|cut -d. -f3`

export LDAP_DOMAIN_DC="dc=$LDAP_DOMAIN_DC1"
export LDAP_PASSWORD="$SLDAP_PASSWORD"

if [ _$LDAP_DOMAIN_DC2 != _ ]; then
    LDAP_DOMAIN_DC="$LDAP_DOMAIN_DC,dc=$LDAP_DOMAIN_DC2"
fi
if [ _$LDAP_DOMAIN_DC3 != _ ]; then
    LDAP_DOMAIN_DC="$LDAP_DOMAIN_DC,dc=$LDAP_DOMAIN_DC3"
fi

envsubst < /opt/fusiondirectory/fusiondirectory.conf > /etc/fusiondirectory/fusiondirectory.conf
yes Yes | fusiondirectory-setup --check-config


# if [ ! -e "/etc/fusiondirectory/fusionready" ]; then
#     yes Yes | fusiondirectory-setup --check-config
#     fusiondirectory-setup --yes --check-ldap << EOF
# admin
# $FUSIONDIRECTORY_PASSWORD
# $FUSIONDIRECTORY_PASSWORD
# EOF
#     touch /etc/fusiondirectory/fusionready
# fi
