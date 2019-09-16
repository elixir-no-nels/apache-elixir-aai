# What it is?
Docker image of a reverse-proxy with AAI authentication component, specifically configured to work with Elixir AAI.

# Usage

Sample `docker-compose.yml` file:

```yaml
version: "3.7"

services:

  ...

  apache:
    image: nels/apache-elixir-aai:latest
    ports:
      - 80:80
      - 443:443
    environment:
      - SERVER_NAME=<your domain name (or localhost)>
      - PROXY_PASS=http://<internal to Docker domain name>:<internal to Docker port>/
      - ELIXIR_AAI_CLIENT_ID=<your Elixir AAI Client ID>
      - ELIXIR_AAI_CLIENT_SECRET=<your Elixir AAI Client Secret>
      - SCOPES="openid profile email" # add more scopes according to your Elixir AAI Client configuration
      - PROTECTED_RESOURCES=/<my protected resource 1>,/<my protected resource 2>
#      - SSL_ENGINE=on
#    volumes:
#      - /etc/letsencrypt/live/<site>/fullchain.pem:/etc/ssl/certs/fullchain.pem
#      - /etc/letsencrypt/live/<site>/privkey.pem:/etc/ssl/private/privkey.pem

```

Last four lines should be uncommented if you want to run Apache over HTTPS.
