Build keycloak image:
```bash
git co https://github.com/canattofilipe/keycloak.git
docker build -t local/keycloak:development ./docker
```

Build kong image:
```bash
git co https://github.com/canattofilipe/kong.git
docker build -t local/kong:development .
```


To avoid that some services try list tenants from Auth (old access control system) is necessary use volumes until new library version be available on repository.
Checkout dojot-module-* to keycloak_10.0.1 and then map it:
```bash
persister:
    image: dojot/persister:development
    volumes: 
      - <dojot-module-python>:/usr/src/venv/lib/python3.6/site-packages/dojot.module-0.0.1a5-py3.6.egg/dojot/module
    restart: always
    ...
```

```bash
data-broker:
    image: dojot/data-broker:development
    volumes: 
    - <dojot-module-nodejs>:/opt/data-broker/node_modules/@dojot/dojot-module
    restart: always
    ...
```
