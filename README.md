# What it is?
A reverse-proxy with AAI authentication component.

# Configuration
1. Generate a server key and a certificate (a default task for Systems Administrator), and either point to them in `Dockerfile` or replace `example.com.crt` and `example.com.key` (if you don't know how, please see _the certificates are wrong section_ below)
2. Update the information in `default-ssl.conf`, to match your needs. Minimally, you need to change:
  - `ServerAdmin` entry to your e-mail address,
  - `ServerName` and `ServerAlias` to match your domain,
  - IP addresses in `ProxyPass` and `ProxyPassReverse` to point to locally accessible resources you want to protect with Elixir AAI,
  - `OICDClientID` to match your _Client ID_  received in the Dynamic Registration process of ELIXIR AAI,
  - `OICDClientSecret` to match your _Client Secret_  received in the Dynamic Registration process of ELIXIR AAI,
  - `OIDCRedirectURI` to match your domain + `/oidc-protected/`,

Optionally, you may want to update `SSLCertificateKeyFile` and `SSLCertificateFile`, if you chose to use other file names for the key and certificate.


# How to use?
First, navigate to the project's path and build the docker image with the following command
(note, that `elixir_aai_proxy` can be changed to any valid container name):
`cd path/to/the/project && docker build . -t elixir_aai_proxy`

Once the image is built, you can run the container by:
`docker run -dit -p 443:443 elixir_aai_proxy`

# Troubleshooting

## The port is already in use
`Error response from daemon: driver failed programming external connectivity on endpoint [NAME_HERE] (LONG_ID_HERE): Bind for 0.0.0.0:443 failed: port is already allocated.`
Please stop other containers, that already use port 443 (see output of `docker ps | grep 443`)

## The certificates are wrong
Please create your own `example.com.crt` and `example.com.key` files using for example: `openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout example.com.key -out example.com.crt`

## There is internal server error
Make sure, that:
 * OpenID Connect is configured properly in `default-ssl.conf`
 * The IPs in proxy configuration match those in OpenID Connect configuraion
 * The IPs in proxy configuration are correct, and end with a slash character (`/`)
