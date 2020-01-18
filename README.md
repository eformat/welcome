### Hello World Image

```
make docker-build
make docker-push
```

### ARGOCD - GitOps

Add your application to argocd
```
oc new-project welcome

argocd repo add git@github.com:eformat/welcome.git --ssh-private-key-path ~/.ssh/id_rsa
argocd app create welcome \
  --repo git@github.com:eformat/welcome.git \
  --path argocd/overlays/cluster1 \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace welcome \
  --revision master \
  --sync-policy automated

argocd app get welcome
argocd app sync welcome --prune
```

Gitops - use make to push and deploy your new image!

```
VERSION=v0.0.7
sed -i -e "s|VERSION :=.*|VERSION := ${VERSION}|g" Makefile
make gitops
```

Delete your application
```
argocd app delete welcome
```
