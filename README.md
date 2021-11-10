# openresty-easy-ssl
A docker container containing an already set up encryption using let's encrypt.

All plain HTTP-requests are redirected to HTTPS. Requests to any subdomain over HTTPS will cause a certificate to be issued automatically.

Deploying with docker-compose:
```YAML
version: "3.8"
services:
  nginx:
    build:
      context: .
    ports:
      - "80:80"
      - "443:443"
    environment:
      # $ needs to be escaped as $$
      - DOMAIN_REGEX=gitdeploy.xyz$$
    restart: always
    volumes:
      - path/to/your/config/servers.conf:/etc/nginx/conf.d/servers.conf:ro
```

The routings are defined in the file /etc/nginx/conf.d/servers.conf, like that:
```
server {
  listen 443 ssl;

  # if this block is included, it will be encrypted
  ssl_certificate_by_lua_block {
    auto_ssl:ssl_certificate()
  }

  location / {
    proxy_pass http://dnt:5000/;
    proxy_read_timeout 1800;
  }

}
```