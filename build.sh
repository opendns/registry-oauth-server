#!/bin/bash

#create certificate used by registry
mkdir -p certs
if [ ! -f cert/server.key ] & [ ! -f certs/server.crt ]; then
    openssl req -subj '/CN=localhost/O=Registry Demo/C=US' -new -newkey rsa:2048 -days 365 -nodes -x509 -keyout certs/server.key -out certs/server.crt
fi


if [ "$(uname)" == "Darwin" ]; then
    docker_ip="$(docker-machine ip default)"
else
    docker_ip="0.0.0.0"
fi

cat <<EOF > docker-compose.yml
registry:
    restart: always
    image: registry:2
    ports:
        - 5000:5000
    environment:
        - REGISTRY_HTTP_TLS_CERTIFICATE=/certs/server.crt
        - REGISTRY_HTTP_TLS_KEY=/certs/server.key
        - REGISTRY_AUTH=token
        - REGISTRY_AUTH_TOKEN_REALM=http://${docker_ip}:8080/tokens
        - REGISTRY_AUTH_TOKEN_SERVICE=demo_registry
        - REGISTRY_AUTH_TOKEN_ISSUER=demo_oauth
        - REGISTRY_AUTH_TOKEN_ROOTCERTBUNDLE=/certs/server.crt
    volumes:
        - ./certs:/certs


oauth_server:
    build: .
    ports:
        - 8080:8080
    volumes:
        - ./certs:/certs
    environment:
        - SIGNING_KEY_PATH=/certs/server.key
        - SIGNING_KEY_TYPE=RSA
        - SIGNING_KEY_ALG=RS256
        - ISSUER=demo_oauth
        - TOKEN_EXPIRATION=3600
        - TOKEN_TYPE=JWT
EOF

docker-compose build
docker-compose up -d
