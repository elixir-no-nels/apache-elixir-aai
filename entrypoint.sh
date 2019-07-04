#!/bin/bash

sed -i 's!SERVER_ADMIN!'${SERVER_ADMIN}'!g' /etc/apache2/sites-available/default-site.conf
sed -i 's!SERVER_URL!'${SERVER_URL}'!g' /etc/apache2/sites-available/default-site.conf
sed -i 's!SERVER_PORT!'${SERVER_PORT}'!g' /etc/apache2/sites-available/default-site.conf
sed -i 's!PROXY_PASS!'${PROXY_PASS}'!g' /etc/apache2/sites-available/default-site.conf
sed -i 's!METADATA_REFRESH_INTERVAL!'${METADATA_REFRESH_INTERVAL:-3600}'!g' /etc/apache2/sites-available/default-site.conf
sed -i 's!ELIXIR_AAI_CLIENT_ID!'${ELIXIR_AAI_CLIENT_ID}'!g' /etc/apache2/sites-available/default-site.conf
sed -i 's!ELIXIR_AAI_CLIENT_SECRET!'${ELIXIR_AAI_CLIENT_SECRET}'!g' /etc/apache2/sites-available/default-site.conf
sed -i 's!REDIRECT_URI!'${REDIRECT_URI:-"/oidc-protected"}'!g' /etc/apache2/sites-available/default-site.conf
sed -i 's!CRYPTO_PASSPHRASE!'${CRYPTO_PASSPHRASE:-salt}'!g' /etc/apache2/sites-available/default-site.conf
sed -i 's!RESPONSE_TYPE!'${RESPONSE_TYPE:-code}'!g' /etc/apache2/sites-available/default-site.conf
sed -i 's!SCOPES!'${SCOPES}'!g' /etc/apache2/sites-available/default-site.conf
sed -i 's!REMOTE_USER_CLAIM!'${REMOTE_USER_CLAIM:-sub}'!g' /etc/apache2/sites-available/default-site.conf
sed -i 's!REQUEST_FIELD_SIZE!'${REQUEST_FIELD_SIZE:-65536}'!g' /etc/apache2/sites-available/default-site.conf

export LOCATIONS=""
IFS=',' read -ra PRS <<< "$PROTECTED_RESOURCES"
for PR in "${PRS[@]}"; do
    export LOCATIONS=$LOCATIONS"		<Location $PR>
    			AuthType openid-connect
    			Require valid-user
    		</Location>

        "
done

# using perl instead of sed here, because sed fails miserably with new lines and slashes
perl -i.bak -pe 's/LOCATIONS/$ENV{"LOCATIONS"}/g' /etc/apache2/sites-available/default-site.conf

sed -i 's!SSL_ENGINE!'${SSL_ENGINE:-off}'!g' /etc/apache2/sites-available/default-site.conf

a2enmod proxy && a2enmod proxy_http && a2enmod ssl && a2enmod auth_openidc

a2ensite default-site

exec "$@"
