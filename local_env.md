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
