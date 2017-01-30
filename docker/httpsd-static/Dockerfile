FROM alpine:latest
LABEL maintainer="Erno Rigo <erno@rigo.info>"
LABEL description="Simple dockerfile based on alpine to provide static web content via https \
self signed certificates are generated automatically. \
The image utilizes openssl, busybox httpd and stunnel to do the heavy lifting."
COPY public /public
COPY work /work
RUN apk update && \
  apk add openssl stunnel
EXPOSE 443
CMD sh /work/gen_cert.sh && ls -laR /public && stunnel /work/stunnel.conf
