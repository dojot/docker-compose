Build keycloak image:

```bash
git clone https://github.com/dojot/dojot.git && cd dojot && git checkout feature-keycloak-10.0.1
docker build -t local/keycloak:development ./docker
```

Build kong image:

```bash
git clone https://github.com/dojot/kong.git && cd kong && git checkout keycloak_10.0.1
docker build -t local/kong:development .
```

To avoid that some services try list tenants from Auth (old access control system) is necessary use volumes until new library version be available on repository.

```bash
DOJOT_MODULE_PYTHON=<dojot-module-python directory>
DOJOT_MODULE_NODEJS=<dojot-module-nodejs directory>
```

iotagent-lwm2m:

```xml
<!-- replace dojot-module-java version -->
    <dependency>
        <groupId>com.github.dojot</groupId>
        <artifactId>dojot-module-java</artifactId>
        <version>6e9cebd903a00e65ac7a9fac00333d769e2fb7a9</version>
        <version>keycloak_10.0.1-SNAPSHOT</version>
    </dependency>
```
