# **Dojot Deploy - Docker compose**

# Table of Contents

1. [Overview](#overview)
1. [Disclaimer](#disclaimer)
1. [Required settings and Recommended settings](#required-settings-and-recommended-settings)
1. [How to get it up and running](#how-to-get-it-up-and-running)
    1. [Deploy Options](#deploy-options)
        1. [How to run on localhost](#how-to-run-on-localhost)
        1. [How to run with HTTPS](#how-to-run-with-https)
            1. [Secure dojot with Let's Encrypt (recommended)](#secure-dojot-with-lets-encrypt-recommended)
                1. [How to schedule domain certificate renewal (recommended and important)](#how-to-schedule-domain-certificate-renewal-recommended-and-important)
            1. [Use HTTPS with self-signed certificate](#use-https-with-self-signed-certificate)
        1. [Run on a domain other than localhost with http (not recommended)](#run-on-a-domain-other-than-localhost-with-http-not-recommended)
    1. [Problems with domain/ip not accessible on docker network](#problems-with-domainip-not-accessible-on-docker-network)
1. [Environment variable](#environment-variable)
    1. [The available variables](#the-available-variables)
    1. [Keycloak SMTP](#keycloak-smtp)
1. [General documentation](#general-documentation)
1. [Issues and help](#issues-and-help)

# Overview
=======
# Dojot Deploy - Docker Compose

This deployment option is best suited to development and functional environments. For production environment we recommend to use [Kubernetes](https://github.com/dojot/ansible-dojot).

## Getting Started

This repository contains the necessary configuration files
for quick deployment of the dojot platform using `docker-compose`.

__Attention__ To get completely ready, **healthy**, all services in this `docker-compose` take an average of at least 12 minutes.

# Disclaimer

This deployment option is best suited to development and functional environments.
For production environment we recommend to use [Kubernetes with Ansible](https://github.com/dojot/ansible-dojot). See how to install on [guide](https://dojotdocs.readthedocs.io/en/latest/installation-guide.html#kubernetes).

# Required settings and Recommended settings

__Required setting:__ Before running this deployment, it is necessary to define a password value in the [.env](./.env) file for the `KEYCLOAK_MASTER_PASSWORD` and `KEYCLOAK_ADMIN_PASSWORD_TEMP`  variables. The value `KEYCLOAK_ADMIN_PASSWORD_TEMP` will be the password of the user *admin* of all tenants (equivalent to realms in the keycloak) when created. **Passwords must have a digit number, a letter in upper case, a letter in lower case, a special character, they cannot be the user or an email and must have 8 characters. If the password does not fit in some cases there will be errors internally when trying to run this `docker-compose`.**

__Recommended setting 1:__ It is recommended to configure Keycloak SMTP, see more in [Keycloak SMTP](#keycloak-smtp).

__Recommended setting 2:__ It is highly recommended to use dojot with security (**https**) for a deployment on a **domain other than `localhost`** follow the guide at [How to run with HTTPS (secure dojot with Let's Encrypt)](#how-to-run-with-https-secure-dojot-with-lets-encrypt---recommended)  and don't forget the item [How to schedule domain certificate renewal](#how-to-schedule-domain-certificate-renewal-recommended-and-important).

__Recommended setting 3:__ The values of secrets must be unique for each environment, to ensure security. Give preference to large random values. The environment variables for these secrets can be found in the `docker.compose.yml` file and are `BS_SESSION_SECRET` in the **backstage** service, `S3ACCESSKEY` and `S3SECRETKEY` in the **image-manager** service, `MINIO_ACCESS_KEY` and `MINIO_SECRET_KEY` in the **minio** service and `KAFKA_WS_TICKET_SECRET` in the **kafka-ws** service.

# How to get it up and running

**Before, it is necessary to do the step [`Required setting`](#required-settings-and-recommended-settings) of the previous topic.**

To use this `docker-compose.yml`, you will need:
=======
This repository contains the necessary configuration files for quick deployment of the Dojot Platform using `docker-compose`.

### Requirements

* Docker Engine >= 19.03 (Installation [here](https://docs.docker.com/engine/install/))
* Docker Compose >= 1.27 (Installation [here](https://docs.docker.com/compose/install/))
> __Note__: All tests were performed with Docker CE on Ubuntu [18.04](https://releases.ubuntu.com/18.04/) and [20.04](https://releases.ubuntu.com/20.04/).


## Usage

Before running this deployment it's necessary to define your domain name or IP in [.env](./.env) file, in the `DOJOT_DOMAIN_NAME` variable.

Both are available in the [Docker official site](https://docs.docker.com/install/). All tests were performed with Docker CE. And also using Ubuntu 18.04 and 20.04.

## Deploy Options

It's important to note that we have four ways to deploy dojot on Docker Compose and these ways will be shown in the topics below.
You should check which way is most interesting for your use case and then follow the respective documentation.

- [How to run on localhost](#how-to-run-on-localhost)
- [How to run with HTTPS](#how-to-run-with-https)
  - [Secure dojot with Let's Encrypt (recommended)](#secure-dojot-with-lets-encrypt-recommended)
    - [How to schedule domain certificate renewal (recommended and important)](#how-to-schedule-domain-certificate-renewal-recommended-and-important)
  - [Use HTTPS with self-signed certificate](#use-https-with-self-signed-certificate)
- [Run on a domain other than localhost with http (not recommended)](#run-on-a-domain-other-than-localhost-with-http-not-recommended)

__Note__ On some machines, when trying to run dojot on port ``80`` or ``433``, there are some internal permission errors in the `apigw (kong)` service. An alternative is to change the port value in ``DOJOT_HTTP_PORT`` to another one like ``8000`` or ``8443``. Also, the ports used by dojot cannot be in use.

### How to run on *localhost*

Just run the command below:

``` sh
sudo docker-compose up  -d
```

After that the dojot must be accessible at `http://localhost:8000`. The tenant will be the value of the `KEYCLOAK_DEFAULT_REALM` variable which by default has the value `admin`, the username will be `admin` and the password the value defined in `KEYCLOAK_ADMIN_PASSWORD_TEMP`.

### How to run with HTTPS

#### Secure dojot with Let's Encrypt (recommended)
Start the containers with command bellow:
=======
To start the containers, the following profiles are available:

- basic (minimum services)
- mongodb-pesistence
- data-processing
- cron-job
- x509-certificates
- front-end
- lwm2m-iot-agent
- device-management
- api-gateway
- user-management
- data-processing-context
- websocket-real-time
- iot-agent-mqtt
- iot-agent-http
- import-export-configuration
- influxdb-persistence
- file-management
- complete (all services)

Start the containers with the minimum services using the command below:
```bash
docker-compose --profile basic up --detach
```
Or start all services with below command:
```
docker-compose --profile complete up --detach
```

> __Note__: To get completely ready, **healthy** :green_heart:, all services in this `docker-compose` take an average of at least `12 minutes`.

For instructions on how to get it up and running, please check [Installation Guide](https://dojotdocs.readthedocs.io/en/latest/installation-guide.html#docker-compose). **Always change the ``admin`` user password to a suitable password and keep it safe.**

Both are available in the [Docker Official Site](https://docs.docker.com/install/).

### How to secure dojot with Nginx and Let's Encrypt

To get dojot running with https and Let's Encrypt you **MUST** ensure you have set up a static public IP address for your server and registered a domain for it.

Add the following lines to the end of the file [.env](./.env) and change `<your domain>` for your registered domain.

``` sh
DOJOT_DOMAIN_NAME=<your domain>

DOJOT_HTTP_PORT=80
DOJOT_HTTPS_PORT=443

DOJOT_ENABLE_HTTPS_ONLY=true
DOJOT_BACKSTAGE_PROXY_SECURE=true

DOJOT_KONG_ROUTE_ALLOW_ONLY_HTTPS=true

DOJOT_URL=https://${DOJOT_DOMAIN_NAME}:${DOJOT_HTTPS_PORT}

KEYCLOAK_REALM_SSL_MODE=EXTERNAL
```

Then change the file `letsencrypt-nginx/nginx-challenge.conf`, replacing __`<YOUR DOMAIN>`__ tag by your registered domain.

After changing `letsencrypt-nginx/nginx-challenge.conf`, run the command below to run the service that will be used by Let's Encrypt to verify your registered domain.

``` sh
sudo docker-compose up -d letsencrypt-nginx
=======
```bash
# Go to the repository letsencrypt-nginx
cd letsencrypt-nginx
# Start the Nginx container
sudo docker-compose --file docker-compose-challenge.yml up --detach
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
```bash
sudo docker container run -it --rm \
    -v /dojot/etc/letsencrypt:/etc/letsencrypt \
    -v /dojot/var/lib/letsencrypt:/var/lib/letsencrypt \
    -v /dojot/letsencrypt-site:/data/letsencrypt \
    -v /dojot/var/log/letsencrypt:/var/log/letsencrypt \
    certbot/certbot \
    certonly --webroot \
    --email <youremail@domain.com> --agree-tos --no-eff-email \
    --webroot-path=/data/letsencrypt \
    -d <your domain>
```

Now that you have your certificate, you have to edit the [.env](./.env) again by adding the variables below. Do **not** remove the variables added in the previous step.

``` sh
KONG_SSL_CERT=/dojot/etc/letsencrypt/live/${DOJOT_DOMAIN_NAME}/fullchain.pem
KONG_SSL_CERT_KEY=/dojot/etc/letsencrypt/live/${DOJOT_DOMAIN_NAME}/privkey.pem
=======
```bash
sudo docker-compose --file docker-compose-challenge.yml down
```

Now run the rest of the dojot services:

``` sh
sudo docker-compose  up -d
=======
```bash
sudo docker-compose --file docker-compose-dojot-https.yml up --detach
```

After that the dojot must be accessible at `https://<your domain>`. The tenant will be the value of the `KEYCLOAK_DEFAULT_REALM` variable which by default has the value `admin`, the username will be `admin` and the password the value defined in `KEYCLOAK_ADMIN_PASSWORD_TEMP`.

###### How to schedule domain certificate renewal (recommended and important)

Periodically, you need to renew the certificate. The process is very simple, run a Certbot command and restart the Nginx. To automate it with a cron job, run:

```bash
# open crontab editor
sudo crontab -e
```

Place the following at the end of the file, then close and save it.

``` sh
0 23 * * * docker run --rm --name certbot -v "/dojot/etc/letsencrypt:/etc/letsencrypt" -v "/dojot/var/lib/letsencrypt:/var/lib/letsencrypt" -v "/dojot/data/letsencrypt:/data/letsencrypt" -v "/dojot/var/log/letsencrypt:/var/log/letsencrypt" certbot/certbot renew --webroot -w /data/letsencrypt --quiet && chmod 0755 /dojot/etc/letsencrypt/{live,archive} && docker restart dojot_apigw_1
```

The above command will run every night at 23:00, renewing the certificate and forcing Kong to restart if the certificate is due for renewal.

##### Use HTTPS with self-signed certificate

To get dojot running with https with self-signed certificate, that domain/ip must be accessible where dojot is running and inside the docker network. See an [alternative solution](#problems-with-domainip-not-accessible-on-docker-network).

As prerequisites this uses [git](https://git-scm.com/) and [OpenSSL](https://www.openssl.org/).

On Debian-based Linux distributions, you can install these prerequisites by running:

``` sh
sudo apt install git openssl
```

After installing the prerequisites if necessary, download the tool to generate certificates [certgen](https://github.com/dojot/dojot/tree/development/tools/certgen) (to see other possible parameters go to [documents](https://github.com/dojot/dojot/tree/development/tools/certgen#readme)):

```sh
git clone --single-branch --branch development https://github.com/dojot/dojot.git cert-tools-temp && cp -r cert-tools-temp/tools/certgen certgen && rm -rf cert-tools-temp
```

Now let's generate the certificate with the commands below, change `<your domain>` or `<your ip>`  for your domain or IP.

For domain case:

```sh
DOJOT_DOMAIN_NAME=<your domain>
sudo ./certgen/bin/certgen.sh \
    --dns ${DOJOT_DOMAIN_NAME} \
    --cname ${DOJOT_DOMAIN_NAME}

sudo chmod -R 0755 certs/ ca/
```

For IP case:

```sh
DOJOT_IP=<your ip>
sudo ./certgen/bin/certgen.sh \
    --ip  ${DOJOT_IP} \
    --cname ${DOJOT_IP}

sudo chmod -R 0755 certs/ ca/
```

Add the following lines to the end of the file [.env](./.env) and change `<your domain>` for your domain or **IP**.

```sh
DOJOT_DOMAIN_NAME=<your domain>

DOJOT_HTTP_PORT=80
DOJOT_HTTPS_PORT=443

DOJOT_ENABLE_HTTPS_ONLY=true

DOJOT_URL=https://${DOJOT_DOMAIN_NAME}:${DOJOT_HTTPS_PORT}

KEYCLOAK_REALM_SSL_MODE=EXTERNAL

KONG_SSL_CERT=/certs/${DOJOT_DOMAIN_NAME}.crt
KONG_SSL_CERT_KEY=/certs/${DOJOT_DOMAIN_NAME}.key
KONG_SSL_CERT_CA=/ca/ca.crt

```

In addition it is necessary to configure in your browser a new *Certificate Authority*, in *chrome* and *firefox* the steps are very close, go to **Settings** then look for **Privacy and Security** and **Security**, and then look for something like **Manage Certificates** or **Certificates**, go to the **Authorities** tab, import the file from `ca/ca.crt` and check the option next to **Thus this CA to identifying websites** and click in **OK**.

__NOTE__ And also when accessing this url via CURL, postman and other such services, via code, it is necessary to use this `ca/ca.crt` file as being a CA, a *Certificate Authority* trustworthy.

After that the dojot must be accessible at `https://<your domain>` in the browser that has been configured with the new **Certification Authority**. The tenant will be the value of the `KEYCLOAK_DEFAULT_REALM` variable which by default has the value `admin`, the username will be `admin` and the password the value defined in `KEYCLOAK_ADMIN_PASSWORD_TEMP`.

### Run on a domain other than localhost with http (not recommended)

**We discourage using this deployment mode for security reasons. Using it is at your own risk.**

To get dojot running with a domain other than localhost with http, that domain/ip must be accessible where dojot is running and inside the docker network. See an alternative solution [alternative solution](#problems-with-domainip-not-accessible-on-docker-network).

Add the following lines to the end of the file [.env](./.env) and change `<your domain>` for your domain or IP. (If you want to use port 8000 add the variable `DOJOT_HTTP_PORT` with 8000 value, It be accessible at `http://<your domain>:8000`.)

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

## Problems with domain/ip not accessible on docker network

When the docker network cannot access the domain or ip where dojot is running there is an alternative solution for this. You can look for the commented out codes in `docker-compose.yml` preceded by the titles `Gateway-static-dojot_default-1`, `Gateway-static-dojot_default-2` and `Gateway-static-dojot_default-3` and uncomment the codes accordingly instructions in comments.

# Environment variable

## The available variables

| Environment variable | Purpose | Default Value | Valid Values
| -------------------- | ------- | ------------- | ------------
| DOJOT_DOMAIN_NAME | Defines the domain name for the dojot infrastructure  | localhost | string
| DOJOT_VERSION | Sets the dojot version that will be used for all the services  | depends on the current branch and tag (**Attention, just changing the version may not be enough,  since each dojot version has its own deployment**) | string
| DOJOT_HTTP_PORT | HTTP port to access the dojot  | 8000 | a port
| DOJOT_HTTPS_PORT | HTTPs port to access the dojot | 8443 | a port
| DOJOT_ENABLE_HTTPS_ONLY | Enables use with HTTPs only  | false | true or false
| DOJOT_URL | URL that dojot is available. For example, `https://www.dojot.com.br`.  | none | url
| DOJOT_BACKSTAGE_PROXY_SECURE | Enables use with HTTPs in backstage proxy  | false | true or false
| COMPOSE_PROJECT_NAME | Sets the project name.  |  dojot | string
| FLOWBROKER_NETWORK | Network used by flowbroker  |  flowbroker | string
| KEYCLOAK_MASTER_USER | Master user name. This user has access to all settings and information for all tenants (equivalent to realms in the keycloak) in the keycloak.  |  master | string
| KEYCLOAK_MASTER_PASSWORD | Password for `KEYCLOAK_MASTER_USER`.  |  none | A string  that must have a digit number, a letter in upper case, a letter in lower case, a special character, they cannot be the user or an email and must have 8 characters.
| KEYCLOAK_ADMIN_PASSWORD_TEMP | The value `KEYCLOAK_ADMIN_PASSWORD_TEMP` will be the password of the user *admin* of all tenants (equivalent to realms in the keycloak) when created. | none | A string  that must have a digit number, a letter in upper case, a letter in lower case, a special character, they cannot be the user or an email and must have 8 characters. If the password does not fit, there will be errors internally when trying to run this `docker-compose`.
| KEYCLOAK_DEFAULT_REALM | Name of the default realm. It will be the default tenant for dojot.  |  admin | string
| KEYCLOAK_REALM_SSL_MODE | **EXTERNAL**: Keycloak can run out of the box without SSL so long as you stick to private IP addresses like localhost, 127.0.0.1, 10.0.x.x, 192.168.x.x, and 172.16.x.x. If you don’t have SSL/HTTPS configured on the server or you try to access Keycloak over HTTP from a non-private IP adress you will get an error. **NONE**: Keycloak does not require SSL. This should really only be used in development when you are playing around with things. **ALL**: Keycloak requires SSL for all IP addresses.  |  NONE | ALL, EXTERNAL or NONE
| KONG_SSL_CERT | Public certificates issued by a public CA, such as lets encrypt. |  none | string path to cert
| KONG_SSL_CERT_KEY | Private key certificates uses to issue a public CA, such as lets encrypt. |  none | string path to cert key
| DOJOT_KONG_ROUTE_ALLOW_ONLY_HTTPS |  Enables using only the https on kong routes.  |  false | true or false

## Keycloak SMTP

To configure the use of password recovery emails, setting passwords, etc., in the keycloak, it is necessary to configure a valid SMTP. These settings must be passed in the `keycloak` service in the `docker-compose.yml` file, they are already commented out there, they being `DOJOT_SMTP_HOST`, `DOJOT_SMTP_PORT`, `DOJOT_SMTP_SSL`,`DOJOT_SMTP_START_TLS`,
`DOJOT_SMTP_FROM`, `DOJOT_SMTP_FROM_DISPLAY_NAME`, `DOJOT_SMTP_USERNAME`, `DOJOT_SMTP_PASSWORD`, to uncomment them and add the necessary values. For more information on these variables, [click here](https://github.com/dojot/dojot/tree/master/iam/keycloak/dojot-provider#smtp-server-configuration).

# General documentation

Check the documentation for more information:

- [Latest dojot platform documentation](https://dojotdocs.readthedocs.io/en/latest)
- [Latest dojot installation guide platform documentation](https://dojotdocs.readthedocs.io/en/latest/installation-guide.html)

# Issues and help

If you found a problem or need help, leave an issue in the main
[dojot repository](https://github.com/dojot/dojot) and we will help you!

=======
```bash
0 23 * * * docker container run --rm --name certbot \
    -v "/dojot/etc/letsencrypt:/etc/letsencrypt" \
    -v "/dojot/var/lib/letsencrypt:/var/lib/letsencrypt" \
    -v "/dojot/data/letsencrypt:/data/letsencrypt" \
    -v "/dojot/var/log/letsencrypt:/var/log/letsencrypt" \
    certbot/certbot renew --webroot -w /data/letsencrypt --quiet && docker restart https-nginx
```

The above command will run every night at 23:00, renewing the certificate and forcing Nginx to restart
if the certificate is due for renewal.

