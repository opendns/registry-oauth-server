# registry-oauth-server

## Quickstart

To build and start the containers, simply run the command

```
./build.sh
```
After installation is finished, you should have a local registry running on *:5000*, and a local oauth server running on *:8080*.

```
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                    NAMES
915726d60e03        demo_oauth_server   "/bin/sh -c 'python r"   8 minutes ago       Up 8 minutes        0.0.0.0:8080->8080/tcp   demo_oauth_server_1
16c5c1cb2310        registry:2          "/bin/registry /etc/d"   2 hours ago         Up 27 minutes       0.0.0.0:5000->5000/tcp   demo_registry_1
```

To see the oauth server in action, run the startdemo.sh script provided

```
./startdemo.sh
```

And you should see a detailed explaination of the oauth handshake process.

##CONFIGURATIONS

The following are a list of environment variables that has to be set for the oauth_server container to work properly.
####SIGNING_KEY_PATH
Specifies the path to the private key used to sign tokens. Must be a valid path inside the container.

####SIGNING_KEY_TYPE
Specifies the type of key used to sign tokens. Can be either RSA or EC, defaults to RSA

####SIGNING_KEY_ALG
Specifies the algorithm used to sign tokens. For RSA keys this should be set to RS256. For EC keys this should be set to ES256

####ISSUER
Identifies who signed the token to the registry. Usually the FQDN of the OAuth Server is used. This configuration should match the REGISTRY_AUTH_TOKEN_ISSUER variable used to configure the registry.

####TOKEN_EXPIRATION
Specifies the expiration time in seconds for tokens signed by this server. Defaults to 3600 seconds.

####TOKEN_TYPE
Specifies the type of tokens signed by this server. Defaults to JWT