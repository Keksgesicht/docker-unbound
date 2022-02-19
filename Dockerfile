FROM alpine

RUN apk update \
 && apk add \
        openssl \
        unbound \
        curl \
 && rm -rf /var/cache/apk/*

RUN adduser unbound tty \
 && chown root:unbound /etc/unbound \
 && chmod 775 /etc/unbound

COPY unbound.conf /unbound.conf
RUN curl -o /root.hints https://www.internic.net/domain/named.cache

RUN mkdir /scripts
COPY scripts/* /scripts/

CMD /bin/sh -c "/scripts/entrypoint.sh && unbound"
