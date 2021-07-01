# dojot Deploy - Docker compose

__Attention__: Before running this deployment, it is necessary to define your domain or IP in the [.env](./.env) file in the variable ``DOJOT_DOMAIN_NAME``.

__Note__ To get completely ready, **healthy**, all services in this `docker-compose` take an average of at least 12 minutes.

This repository contains the necessary configuration files
for quick deployment of the dojot platform using docker-compose.

For instructions on how to get it up and running, please check [Installation Guide](https://dojotdocs.readthedocs.io/en/latest/installation-guide.html#docker-compose)

To use this docker-compose.yml, you will need:

- Docker engine > 19.03
- docker-compose > 1.27

Both are available in the [Docker official site](https://docs.docker.com/install/)_. All tests were performed with Docker CE. And also using Ubuntu 18.04 and 20.04.

## Disclaimer

This deployment option is best suited to development and functional environments.
For production environment we recommend to use Kubernetes.

## How to secure dojot with Nginx and Let's Encrypt

To get dojot running with https, at least for the purposes of this guide, you **MUST** ensure
you have set up a static public IP address for your server and registered a domain for it. Then
just follow the next steps.

Firstly, configure a temporary [Nginx](https://www.nginx.com/) server that only runs
on HTTP and gives the [Certbot](https://certbot.eff.org/) tool write access for the following
endpoint: http://<your domain>/.well-known/acme-challenge/{token}. This endpoint will be used
to answer Let's Encrypt CA's challenge, which is part of the process of getting a certificate
for your server.

To make the things easier, there is a docker-compose configuration file in
letsencrypt-nginx/docker-compose-challenge.yml. **But, before starting it, change the
file letsencrypt-nginx/nginx-challenge.conf, replacing **<YOUR DOMAIN>** tag by your registered domain**.
Then spin up Nginx:

``` sh
# Go to the repository letsencrypt-nginx
cd letsencrypt-nginx
# Start the Nginx container
sudo docker-compose -f docker-compose-challenge.yml up -d
```

The next step is to run Certbot tool. **Change the command bellow to use your
email address and your domain, and just run it**.

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
-d <your domain>
```

If everything ran successfully, stop the temporary Nginx server because it is no more necessary:

``` sh
sudo docker-compose -f docker-compose-challenge.yml down
```

Now you have a certificate for your domain. The next step, is to configure a
Nginx to receive the https requests and redirect the traffic to dojot's api gateway.

This Nginx service is specified in the docker-compose file
letsencrypt-nginx/docker-compose-dojot-https.yml. It MUST run in the same network of
other dojot's services. So before starting it, change the network in the configuration
if necessary and replace the tag **<YOUR DOMAIN>** by the your registered domain
in the files: letsencrypt-nginx/docker-compose-dojot-https.yml and letsencrypt-nginx/nginx-dojot-https.conf.
Then spin up Nginx:

``` sh
sudo docker-compose -f docker-compose-dojot-https.yml up -d
```

Now, open up a browser and visit https://<YOUR DOMAIN>. You should see the dojot's graphical interface.

Periodically, you need to renew the certificate. The process is very simple, run a Certbot command
and restart the Nginx. To automate it with a cron job, run:

``` sh
# open crontab editor
sudo crontab -e
```

Place the following at the end of the file, then close and save it.

``` sh
0 23 * * * docker run --rm --name certbot -v "/dojot/etc/letsencrypt:/etc/letsencrypt" -v "/dojot/var/lib/letsencrypt:/var/lib/letsencrypt" -v "/dojot/data/letsencrypt:/data/letsencrypt" -v "/dojot/var/log/letsencrypt:/var/log/letsencrypt" certbot/certbot renew --webroot -w /data/letsencrypt --quiet && docker restart https-nginx
```

The above command will run every night at 23:00, renewing the certificate and forcing Nginx to restart
if the certificate is due for renewal.

