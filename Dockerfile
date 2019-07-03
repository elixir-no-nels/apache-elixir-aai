FROM ubuntu:latest

RUN apt-get update && apt-get install -y apache2 libapache2-mod-auth-openidc

COPY default-site.conf /etc/apache2/sites-available/default-site.conf

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["apachectl", "-D", "FOREGROUND"]
