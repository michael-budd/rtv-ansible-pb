#!/usr/bin/env bash

## If environment variables not set, set defaults
[[ -z ${SAMBA_REALM} ]] && export SAMBA_REALM='RTVCHALLENGE.NET'
[[ -z ${SAMBA_WORKGROUP} ]] && export SAMBA_WORKGROUP='RTVCHALLENGE'
[[ -z ${SAMBA_USERNAME} ]] && export SAMBA_USERNAME='administrator'
[[ -z ${SAMBA_PASSWORD} ]] && export SAMBA_PASSWORD='X3E5Op3RH1US4ok5'

## Provision domain controller
samba-tool domain provision --server-role=dc --use-rfc2307 --dns-backend=SAMBA_INTERNAL \
    --realm=${SAMBA_REALM} \
    --domain=${SAMBA_WORKGROUP} \
    --adminpass=${SAMBA_PASSWORD} \
    --option="idmap config * : range = 655-65533" \
    --option="vfs objects = acl_xattr xattr_tdb" 

## Create users
users_file='/users.txt'

if [[ -e ${users_file} ]]
then
    for line in $(cat ${users_file})
    do
        echo "line: ${line}"
        user="$(echo ${line} | cut -d ':' -f 1)"
        password="$(echo ${line} | cut -d ':' -f 2)"
    
        printf "${password}\n${password}\n" | smbpasswd -a "${user}" &&\
    	echo "${user} user created!"
    done
fi

## Run samba
/usr/sbin/samba --foreground --no-process-group
