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
```bash
DOJOT_MODULE_PYTHON=<dojot-module-python directory>
DOJOT_MODULE_NODEJS=<dojot-module-nodejs directory>>
```
