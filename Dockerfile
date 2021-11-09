FROM openresty/openresty:alpine-fat

# Include env var in nginx config
RUN sed -i '1i env DOMAIN_REGEX;' /usr/local/openresty/nginx/conf/nginx.conf

# Install inotify to autoreload nginx-config on changes
RUN apk update
RUN apk add inotify-tools
RUN apk add openssl

# install lua-resty-auto-ssl
RUN /usr/local/openresty/luajit/bin/luarocks install lua-resty-auto-ssl

# create storage dir for auto-ssl
RUN mkdir /etc/resty-auto-ssl
RUN chmod 777 /etc/resty-auto-ssl

# creating fallback certificates
RUN openssl req -new -newkey rsa:2048 -days 3650 -nodes -x509 \
      -subj '/CN=sni-support-required-for-valid-ssl' \
      -keyout /etc/ssl/resty-auto-ssl-fallback.key \
      -out /etc/ssl/resty-auto-ssl-fallback.crt

COPY ./nginxReloader.sh /usr/local/openresty/bin/nginxReloader.sh
COPY ./docker-entrypoint.sh /usr/local/openresty/bin/docker-entrypoint.sh

RUN chmod +x /usr/local/openresty/bin/nginxReloader.sh
RUN chmod +x /usr/local/openresty/bin/docker-entrypoint.sh

ENTRYPOINT [ "/usr/local/openresty/bin/docker-entrypoint.sh" ]
CMD ["/usr/local/openresty/bin/openresty", "-g", "daemon off;"]