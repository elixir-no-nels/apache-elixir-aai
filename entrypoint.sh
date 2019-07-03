#!/bin/bash

sed -i 's!SERVER_ADMIN!'${SERVER_ADMIN}'!g' /etc/apache2/sites-available/default-site.conf
sed -i 's!SERVER_URL!'${SERVER_URL}'!g' /etc/apache2/sites-available/default-site.conf
sed -i 's!PROXY_PASS!'${PROXY_PASS}'!g' /etc/apache2/sites-available/default-site.conf
sed -i 's!ELIXIR_AAI_CLIENT_ID!'${ELIXIR_AAI_CLIENT_ID}'!g' /etc/apache2/sites-available/default-site.conf
sed -i 's!ELIXIR_AAI_CLIENT_SECRET!'${ELIXIR_AAI_CLIENT_SECRET}'!g' /etc/apache2/sites-available/default-site.conf

a2enmod proxy && a2enmod proxy_http && a2enmod ssl && a2enmod auth_openidc

a2ensite default-site

exec "$@"
