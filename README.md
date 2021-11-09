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
      - path/to/your/config/default.conf:/etc/nginx/conf.d/default.conf:ro
```

The routings are defined in the file /etc/nginx/conf.d/locations.conf, like that:
```
location / {
  proxy_pass http://dnt:5000/;
  proxy_read_timeout 1800;
}
```