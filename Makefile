# Image URL to use all building/pushing image targets
REGISTRY ?= quay.io
REPOSITORY ?= $(REGISTRY)/eformat/welcome

IMG := $(REPOSITORY):latest
VERSION := v0.0.8

# podman Login
podman-login:
	@podman login -u $(PODMAN_USER) -p $(PODMAN_PASSWORD) $(REGISTRY)

# Tag for Dev
podman-tag-dev:
	@podman tag $(IMG) $(REPOSITORY):dev

# Tag for Dev
podman-tag-release:
	@podman tag $(IMG) $(REPOSITORY):$(VERSION)
	@podman tag $(REPOSITORY):$(VERSION) $(REPOSITORY):latest	

# Push for Dev
podman-push-dev:  podman-tag-dev
	@podman push $(REPOSITORY):dev

# Push for Release
podman-push-release:  podman-tag-release
	@podman push $(REPOSITORY):$(VERSION)
	@podman push $(REPOSITORY):latest

# Build the podman image
podman-build:
	cd sh && podman build --platform linux/amd64 . -t ${IMG} -t ${IMG}-x86_64 -f Dockerfile.ubi
	cd sh && podman build --platform linux/arm64 . -t ${IMG}-aarch64 -f Dockerfile.ubi

# Push the podman image
podman-push: podman-build
	podman push ${IMG}
	podman push ${IMG}-x86_64
	podman push ${IMG}-aarch64

update-is:
	sed -i -e "s|      name:.*$$|      name: $(REPOSITORY):$(VERSION)|g" argocd/base/imagestream.yaml

# git commit
commit-source:
	git add .
	git commit -m "new image update"
	git push

# argocd sync (must be logged into arcocd)
argocd-sync:
	argocd app sync welcome --prune --force

# gitops target
gitops: update-is podman-tag-release podman-push-release commit-source argocd-sync