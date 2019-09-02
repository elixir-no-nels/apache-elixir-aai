#!/bin/bash

sed -i 's!SERVER_NAME!'${SERVER_NAME}'!g' /etc/apache2/sites-available/default-site.conf
sed -i 's!PROXY_PASS!'${PROXY_PASS}'!g' /etc/apache2/sites-available/default-site.conf
sed -i 's!METADATA_REFRESH_INTERVAL!'${METADATA_REFRESH_INTERVAL:-3600}'!g' /etc/apache2/sites-available/default-site.conf
sed -i 's!ELIXIR_AAI_CLIENT_ID!'${ELIXIR_AAI_CLIENT_ID}'!g' /etc/apache2/sites-available/default-site.conf
sed -i 's!ELIXIR_AAI_CLIENT_SECRET!'${ELIXIR_AAI_CLIENT_SECRET}'!g' /etc/apache2/sites-available/default-site.conf
sed -i 's!REDIRECT_URI!'${REDIRECT_URI:-"/oidc-protected"}'!g' /etc/apache2/sites-available/default-site.conf
sed -i 's!CRYPTO_PASSPHRASE!'${CRYPTO_PASSPHRASE:-salt}'!g' /etc/apache2/sites-available/default-site.conf
sed -i 's!RESPONSE_TYPE!'${RESPONSE_TYPE:-code}'!g' /etc/apache2/sites-available/default-site.conf
sed -i 's!REMOTE_USER_CLAIM!'${REMOTE_USER_CLAIM:-sub}'!g' /etc/apache2/sites-available/default-site.conf
sed -i 's!REQUEST_FIELD_SIZE!'${REQUEST_FIELD_SIZE:-65536}'!g' /etc/apache2/sites-available/default-site.conf

export LOCATIONS=""
IFS=',' read -ra PRS <<< "$PROTECTED_RESOURCES"
for PR in "${PRS[@]}"; do
    export LOCATIONS=$LOCATIONS"		<Location $PR>
    			AuthType openid-connect
    			Require valid-user
                OIDCUnAuthAction auth
    		</Location>

        "
done

# using perl instead of sed here, because sed fails miserably with new lines and slashes
perl -i.bak -pe 's/SCOPES/$ENV{"SCOPES"}/g' /etc/apache2/sites-available/default-site.conf
perl -i.bak -pe 's/LOCATIONS/$ENV{"LOCATIONS"}/g' /etc/apache2/sites-available/default-site.conf

sed -i 's!SSL_ENGINE!'${SSL_ENGINE:-off}'!g' /etc/apache2/sites-available/default-site.conf

if [ "$SSL_ENGINE" == "on" ]; then
    sed -i 's!SERVER_PORT!443!g' /etc/apache2/sites-available/default-site.conf
    export REDIRECT_SECTION="
    <VirtualHost *:80>
      ServerName $SERVER_NAME
      DocumentRoot /var/www/html
      Redirect permanent / https://$SERVER_NAME/
    </VirtualHost>
        "
    # using perl instead of sed here, because sed fails miserably with new lines and slashes
    perl -i.bak -pe 's/REDIRECT_COMMENT/$ENV{"REDIRECT_SECTION"}/g' /etc/apache2/sites-available/default-site.conf
    sed -i 's!SSL_COMMENT!!g' /etc/apache2/sites-available/default-site.conf
else
    sed -i 's!SERVER_PORT!80!g' /etc/apache2/sites-available/default-site.conf
    sed -i 's!REDIRECT_COMMENT!!g' /etc/apache2/sites-available/default-site.conf
    sed -i 's!SSL_COMMENT!#!g' /etc/apache2/sites-available/default-site.conf
fi

a2enmod proxy && a2enmod proxy_http && a2enmod ssl && a2enmod headers && a2enmod auth_openidc

a2ensite default-site

exec "$@"
