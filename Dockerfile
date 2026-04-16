FROM serversideup/php:8.4-fpm-nginx

WORKDIR /var/www/html
ENV AUTORUN_ENABLED=true
ENV AUTORUN_LARAVEL_MIGRATION=true

USER root

RUN apt-get update && apt-get install -y curl jq unzip netcat-openbsd git

RUN curl -fsSL https://releases.hashicorp.com/vault/1.21.4/vault_1.21.4_linux_amd64.zip -o vault.zip \
    && unzip vault.zip \
    && mv vault /usr/local/bin/ \
    && rm vault.zip

COPY .docker/entrypoint/60-vault.sh /etc/entrypoint.d/60-vault.sh
RUN chmod 755 /etc/entrypoint.d/60-vault.sh && chown root:root /etc/entrypoint.d/60-vault.sh

COPY --chown=www-data:www-data composer.json composer.lock ./
RUN composer install 

COPY --chown=www-data:www-data . /var/www/html

USER www-data
