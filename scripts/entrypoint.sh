#!/bin/sh

if ! [ -f /etc/unbound/unbound.conf ]; then
	cp /unbound.conf /etc/unbound/unbound.conf
fi

if ! [ -f /etc/unbound/root.hints ] || [ /etc/unbound/root.hints -ot /root.hints ]; then
	cp /root.hints /etc/unbound/root.hints
fi

mkdir -p /etc/unbound/keys
chmod +w /etc/unbound/keys
chown -R unbound /etc/unbound

unbound-anchor -4 -r /etc/unbound/root.hints -a /etc/unbound/keys/trusted.key
unbound-control-setup -d /etc/unbound/keys/

unbound-checkconf /etc/unbound/unbound.conf
if [ "$?" != "0" ] ; then
	echo "#=======================#"
	echo "| ERROR: CONFIG DAMAGED |"
	echo "#=======================#"
	exit 1
fi
