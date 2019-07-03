FROM ubuntu:latest
MAINTAINER jacek.lebioda@uni.lu

RUN apt-get update && apt-get install -y apache2 libapache2-mod-auth-openidc

COPY default-ssl.conf /etc/apache2/sites-available/default-ssl.conf
COPY example.com.crt /etc/ssl/certs/example.com.crt
COPY example.com.key /etc/ssl/private/example.com.key

RUN a2enmod proxy && a2enmod proxy_http && a2enmod ssl && a2enmod auth_openidc
RUN a2ensite default-ssl

CMD ["apachectl", "-D", "FOREGROUND"]
EXPOSE 80
