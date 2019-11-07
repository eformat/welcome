# Image URL to use all building/pushing image targets
REGISTRY ?= quay.io
REPOSITORY ?= $(REGISTRY)/eformat/welcome

IMG := $(REPOSITORY):latest
VERSION := v0.0.4

# Docker Login
docker-login:
	@docker login -u $(DOCKER_USER) -p $(DOCKER_PASSWORD) $(REGISTRY)

# Tag for Dev
docker-tag-dev:
	@docker tag $(IMG) $(REPOSITORY):dev

# Tag for Dev
docker-tag-release:
	@docker tag $(IMG) $(REPOSITORY):$(VERSION)
	@docker tag $(IMG) $(REPOSITORY):latest	

# Push for Dev
docker-push-dev:  docker-tag-dev
	@docker push $(REPOSITORY):dev

# Push for Release
docker-push-release:  docker-tag-release
	@docker push $(REPOSITORY):$(VERSION)
	@docker push $(REPOSITORY):latest

# Build the docker image
docker-build:
	cd sh && docker build . -t ${IMG} -f Dockerfile

# Push the docker image
docker-push: docker-build
	docker push ${IMG}

# ArgoCD commands for image update
update-dc:
	sed -i -e "s|      - image:.*$$|      - image: ${REPOSITORY}:${VERSION}|g" argocd/deploymentconfig.yaml

update-is:
	sed -i -e "s|      name:.*$$|      name: $(REPOSITORY):$(VERSION)|g" argocd/imagestream.yaml

# git commit
commit-source:
	git add .
	git commit -m "new image update"
	git push

# argocd sync (must be logged into arcocd)
argocd-sync:
	argocd app sync welcome --prune --force

# gitops target
gitops: update-dc update-is commit-source argocd-sync