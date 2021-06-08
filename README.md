# Dojot Deploy - Docker compose

## Table of Contents

1. [Overview](#overview)
1. [Disclaimer](#disclaimer)
1. [Required settings and Recommended settings](#required-settings-and-recommended-settings)
1. [How to get it up and running](#how-to-get-it-up-and-running)
    1. [How to run on localhost](#how-to-run-on-localhost)
    1. [How to run on a domain other than localhost with http (not recommended)](#how-to-run-on-a-domain-other-than-localhost-with-http-not-recommended)
    1. [How to run with HTTPS (secure dojot with Let's Encrypt) - recommended](#how-to-run-with-https-secure-dojot-with-lets-encrypt---recommended)
        1. [How to schedule domain certificate renewal (recommended and important)](#how-to-schedule-domain-certificate-renewal-recommended-and-important)
1. [Environment variable](#environment-variable)
    1. [The available variables](#the-available-variables)
    1. [Keycloak SMTP](#keycloak-smtp)
1. [General documentation](#general-documentation)
1. [Issues and help](#issues-and-help)

## Overview

This repository contains the necessary configuration files
for quick deployment of the dojot platform using `docker-compose`.

## Disclaimer

This deployment option is best suited to development and functional environments.
For production environment we recommend to use [Kubernetes with Ansible](https://github.com/dojot/ansible-dojot). See how to install on [guide](https://dojotdocs.readthedocs.io/en/latest/installation-guide.html#kubernetes).

## Required settings and Recommended settings

__Required setting:__ Before running this deployment, it is necessary to define a password value in the [.env](./.env) file for the `KEYCLOAK_MASTER_PASSWORD` and `KEYCLOAK_ADMIN_PASSWORD_TEMP`  variables. The value `KEYCLOAK_ADMIN_PASSWORD_TEMP` will be the password of the user *admin* of all tenants (equivalent to realms in the keycloak) when created. **Passwords must have a digit number, a letter in upper case, a letter in lower case, a special character, they cannot be the user or an email and must have 8 characters. If the password does not fit in some cases there will be errors internally when trying to run this `docker-compose`.**

__Recommended setting 1:__ It is recommended to configure Keycloak SMTP, see more in [Keycloak SMTP](#keycloak-smtp).

__Recommended setting 2:__ It is highly recommended to use dojot with security (**https**) for a deployment on a **domain other than `localhost`** follow the guide at [How to run with HTTPS (secure dojot with Let's Encrypt)](#how-to-run-with-https-secure-dojot-with-lets-encrypt---recommended)  and don't forget the item [How to schedule domain certificate renewal](#how-to-schedule-domain-certificate-renewal-recommended-and-important).

__Recommended setting 3:__ The values of secrets must be unique for each environment, to ensure security. Give preference to large random values. The environment variables for these secrets can be found in the `docker.compose.yml` file and are `BS_SESSION_SECRET` in the **backstage** service, `S3ACCESSKEY` and `S3SECRETKEY` in the **image-manager** service, `MINIO_ACCESS_KEY` and `MINIO_SECRET_KEY` in the **minio** service and `KAFKA_WS_TICKET_SECRET` in the **kafka-ws** service.

## How to get it up and running

**Before, it is necessary to do the step [`Required setting`](#required-settings-and-recommended-settings) of the previous topic.**

To use this `docker-compose.yml`, you will need:

- Docker engine > 19.03
- docker-compose > 1.27

Both are available in the [Docker official site](https://docs.docker.com/install/). All tests were performed with Docker CE. And also using Ubuntu 18.04 and 20.04.

### How to run on *localhost*

Just run the command below:

``` sh
sudo docker-compose up  -d
```

After that the dojot must be accessible at `http://localhost:8000`. The tenant will be the value of the `KEYCLOAK_DEFAULT_REALM` variable which by default has the value `admin`, the username will be `admin` and the password the value defined in `KEYCLOAK_ADMIN_PASSWORD_TEMP`.

### How to run on a domain *other than localhost* with http (not recommended)

To get dojot running with http on a domain other than localhost, at least for the purposes of this guide, you **MUST** ensure you have set up a static public IP address for your server and registered a domain for it. Then just follow the next steps. *And that domain must be accessible where dojot is running, an alternative solution for this is look for the commented out codes in `docker-compose.yml` preceded by the titles `Gateway-static-dojot _default-1`, `Gateway-static-dojot_default-2` and `Gateway-static-dojot_default-3` and uncomment the codes accordingly instructions.*

Add the following lines to the end of the file [.env](./.env) and change `<your domain>` for your registered domain. (If you want to use port 8000 do not add the variable `DOJOT_HTTP_PORT`, It be accessible at `http://<your domain>:8000`.)

``` sh
DOJOT_DOMAIN_NAME=<your domain>

DOJOT_HTTP_PORT=80

DOJOT_URL=http://${DOJOT_DOMAIN_NAME}:${DOJOT_HTTP_PORT}

```

Then run the command below:

``` sh
sudo docker-compose up  -d
```

After that the dojot must be accessible at `http://<your domain>`. The tenant will be the value of the `KEYCLOAK_DEFAULT_REALM` variable which by default has the value `admin`, the username will be `admin` and the password the value defined in `KEYCLOAK_ADMIN_PASSWORD_TEMP`.

## How to run with HTTPS (secure dojot with Let's Encrypt) - recommended

To get dojot running with https, at least for the purposes of this guide, you **MUST** ensure you have set up a static public IP address for your server and registered a domain for it. Then just follow the next steps. *And that domain must be accessible where dojot is running, , an alternative solution for this is look for the commented out codes in `docker-compose.yml` preceded by the titles `Gateway-static-dojot _default-1`, `Gateway-static-dojot_default-2` and `Gateway-static-dojot_default-3` and uncomment the codes accordingly instructions.*

Add the following lines to the end of the file [.env](./.env) and change `<your domain>` for your registered domain.

``` sh
DOJOT_DOMAIN_NAME=<your domain>

DOJOT_HTTP_PORT=80
DOJOT_HTTPS_PORT=443

DOJOT_ENABLE_HTTPS_ONLY=true

DOJOT_URL=https://${DOJOT_DOMAIN_NAME}:${DOJOT_HTTPS_PORT}

KEYCLOAK_REALM_SSL_MODE=EXTERNAL
```

Then change the file `letsencrypt-nginx/nginx-challenge.conf`, replacing __`<YOUR DOMAIN>`__ tag by your registered domain.

After changing `letsencrypt-nginx/nginx-challenge.conf`, run the command below to run the service that will be used by Let's Encrypt to verify your registered domain.

``` sh
sudo docker-compose up -d letsencrypt-nginx
```

Run the command below by changing the `<your domain>` and `<youremail@domain.com>` values, to perform domain ownership verification.

``` sh
sudo docker run -it --rm \
-v /dojot/etc/letsencrypt:/etc/letsencrypt \
-v /dojot/var/lib/letsencrypt:/var/lib/letsencrypt \
-v /dojot/letsencrypt-site:/data/letsencrypt \
-v /dojot/var/log/letsencrypt:/var/log/letsencrypt \
certbot/certbot \
certonly --webroot \
--email <youremail@domain.com> --agree-tos --no-eff-email \
--webroot-path=/data/letsencrypt \
-d <your domain>; sudo chmod -R 0755 /dojot/etc/letsencrypt/{live,archive}
```

Now that you have your certificate, you have to edit the [.env](./.env) again by adding the variables below. Do **not** remove `DOJOT_DOMAIN_NAME`, `DOJOT_HTTP_PORT` and `DOJOT_HTTPS_PORT`.

``` sh
KONG_SSL_CERT=/dojot/etc/letsencrypt/live/${DOJOT_DOMAIN_NAME}/fullchain.pem
KONG_SSL_CERT_KEY=/dojot/etc/letsencrypt/live/${DOJOT_DOMAIN_NAME}/privkey.pem
```

Now run the rest of the dojot services:

``` sh
sudo docker-compose  up -d
```

After that the dojot must be accessible at `https://<your domain>`. The tenant will be the value of the `KEYCLOAK_DEFAULT_REALM` variable which by default has the value `admin`, the username will be `admin` and the password the value defined in `KEYCLOAK_ADMIN_PASSWORD_TEMP`.

### How to schedule domain certificate renewal (recommended and important)

Periodically, you need to renew the certificate. The process is very simple, run a Certbot command and restart the Nginx. To automate it with a cron job, run:

``` sh
# open crontab editor
sudo crontab -e
```

Place the following at the end of the file, then close and save it.

``` sh
0 23 * * * docker run --rm --name certbot -v "/dojot/etc/letsencrypt:/etc/letsencrypt" -v "/dojot/var/lib/letsencrypt:/var/lib/letsencrypt" -v "/dojot/data/letsencrypt:/data/letsencrypt" -v "/dojot/var/log/letsencrypt:/var/log/letsencrypt" certbot/certbot renew --webroot -w /data/letsencrypt --quiet && chmod 0755 /dojot/etc/letsencrypt/{live,archive} && docker restart dojot_apigw_1
```

The above command will run every night at 23:00, renewing the certificate and forcing Kong to restart if the certificate is due for renewal.

## Environment variable

### The available variables

| Environment variable | Purpose | Default Value | Valid Values
| -------------------- | ------- | ------------- | ------------
| DOJOT_DOMAIN_NAME | Defines the domain name for the dojot infrastructure  | localhost | string
| DOJOT_VERSION | Sets the dojot version that will be used for all the services  | depends on the current branch and tag (**Attention, just changing the version may not be enough,  since each dojot version has its own deployment**) | string
| DOJOT_HTTP_PORT | HTTP port to access the dojot  | 8000 | a port
| DOJOT_HTTPS_PORT | HTTPs port to access the dojot | 8443 | a port
| DOJOT_ENABLE_HTTPS_ONLY | Enables use with HTTPs only  | false | true or false
| DOJOT_URL | URL that dojot is available. For example, `https://www.dojot.com.br`.  | none | url
| COMPOSE_PROJECT_NAME | Sets the project name.  |  dojot | string
| FLOWBROKER_NETWORK | Network used by flowbroker  |  flowbroker | string
| KEYCLOAK_MASTER_USER | Master user name. This user has access to all settings and information for all tenants (equivalent to realms in the keycloak) in the keycloak.  |  master | string
| KEYCLOAK_MASTER_PASSWORD | Password for `KEYCLOAK_MASTER_USER`.  |  none | A string  that must have a digit number, a letter in upper case, a letter in lower case, a special character, they cannot be the user or an email and must have 8 characters.
| KEYCLOAK_ADMIN_PASSWORD_TEMP | The value `KEYCLOAK_ADMIN_PASSWORD_TEMP` will be the password of the user *admin* of all tenants (equivalent to realms in the keycloak) when created. | none | A string  that must have a digit number, a letter in upper case, a letter in lower case, a special character, they cannot be the user or an email and must have 8 characters. If the password does not fit, there will be errors internally when trying to run this `docker-compose`.
| KEYCLOAK_DEFAULT_REALM | Name of the default realm. It will be the default tenant for dojot.  |  admin | string
| KEYCLOAK_REALM_SSL_MODE | **EXTERNAL**: Keycloak can run out of the box without SSL so long as you stick to private IP addresses like localhost, 127.0.0.1, 10.0.x.x, 192.168.x.x, and 172.16.x.x. If you don’t have SSL/HTTPS configured on the server or you try to access Keycloak over HTTP from a non-private IP adress you will get an error. **NONE**: Keycloak does not require SSL. This should really only be used in development when you are playing around with things. **ALL**: Keycloak requires SSL for all IP addresses.  |  NONE | ALL, EXTERNAL or NONE
| KONG_SSL_CERT | Public certificates issued by a public CA, such as lets encrypt. |  none | string path to cert
| KONG_SSL_CERT_KEY | Private key certificates uses to issue a public CA, such as lets encrypt. |  none | string path to cert key

### Keycloak SMTP

To configure the use of password recovery emails, setting passwords, etc., in the keycloak, it is necessary to configure a valid SMTP. These settings must be passed in the `keycloak` service in the `docker-compose.yml` file, they are already commented out there, they being `DOJOT_SMTP_HOST`, `DOJOT_SMTP_PORT`, `DOJOT_SMTP_SSL`,`DOJOT_SMTP_START_TLS`,
`DOJOT_SMTP_FROM`, `DOJOT_SMTP_FROM_DISPLAY_NAME`, `DOJOT_SMTP_USERNAME`, `DOJOT_SMTP_PASSWORD`, to uncomment them and add the necessary values. For more information on these variables, [click here](https://github.com/dojot/dojot/tree/master/iam/keycloak/dojot-provider#smtp-server-configuration).

## General documentation

Check the documentation for more information:

- [Latest dojot platform documentation](https://dojotdocs.readthedocs.io/en/latest)
- [Latest dojot installation guide platform documentation](https://dojotdocs.readthedocs.io/en/latest/installation-guide.html)

## Issues and help

If you found a problem or need help, leave an issue in the main
[dojot repository](https://github.com/dojot/dojot) and we will help you!
