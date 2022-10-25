FROM ubuntu:22.04

## Install SMB dependencies
RUN apt-get update &&\
    apt-get install -y acl \
        samba \
        smbclient \
        krb5-config \
        krb5-user \
        winbind \
        libpam-winbind \
        libnss-winbind 

RUN rm /etc/krb5.conf && ln -s /var/lib/samba/private/krb5.conf /etc/krb5.conf
RUN rm /etc/samba/smb.conf

COPY idmap_init.ldif /usr/share/samba/setup/idmap_init.ldif
COPY entrypoint.sh /entrypoint.sh 

## Copy users.txt 
COPY users.txt /users.txt

## Ports to expose
EXPOSE 88
EXPOSE 139
EXPOSE 445

ENTRYPOINT /entrypoint.sh
