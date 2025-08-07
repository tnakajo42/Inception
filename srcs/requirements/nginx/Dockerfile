FROM alpine:3.18

RUN apk update && apk add --no-cache nginx openssl bash gettext

RUN mkdir -p /etc/ssl/certs /etc/ssl/private /run/nginx

COPY ssl/cert.pem /etc/ssl/certs/cert.pem
COPY ssl/key.pem /etc/ssl/private/key.pem

COPY conf/default.conf.template /etc/nginx/http.d/default.conf.template
COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
