### Hello World Image

```
make docker-build
make docker-push
```

### ARGOCD - GitOps

Deploy argocd

```
oc new-project argocd --display-name="ArgoCD" --description="ArgoCD"
oc apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/release-1.2/manifests/install.yaml
sudo curl -L  https://github.com/argoproj/argo-cd/releases/download/v1.2.2/argocd-linux-amd64 -o /usr/bin/argocd
sudo chmod +x /usr/bin/argocd

oc port-forward svc/argocd-server -n argocd 4443:443 &

Login to Argocd Web Console (use FireFox) - https://localhost:4443

-- admin password is podname
PWD=$(oc get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2)

argocd login localhost:4443 --insecure --username admin --password $PWD
argocd account update-password --insecure
argocd relogin
```

Configure to ignore image sha's on sync for container [0] else we never sync

```
-- ignore first image in sync for deployment config
oc edit cm argocd-cm -n argocd

resource.customizations: |
  apps.openshift.io/DeploymentConfig:
    ignoreDifferences: |
      jsonPointers:
      - /spec/template/spec/containers/0/image
```

Add your application to argocd

```
argocd repo add git@github.com:eformat/welcome.git 

oc new-project welcome

argocd repo add git@github.com:eformat/welcome.git --ssh-private-key-path ~/.ssh/id_rsa
argocd app create welcome \
  --repo git@github.com:eformat/welcome.git \
  --path argocd \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace welcome

argocd app get welcome
argocd app sync welcome --prune
```

Delete you application

```
argocd app delete welcome
```

Gitops - use make to push and deploy your new image!

```
VERSION=v0.0.5
sed -i -e "s|VERSION :=.*|VERSION := ${VERSION}|g" Makefile
make gitops
```