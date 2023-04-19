REPOSITORY ?= joseluisq/alpine-curl
TAG ?= latest

build:
	docker build \
		-t $(REPOSITORY):$(TAG) \
		-f Dockerfile .
.PHONY: build

buildx:
	docker buildx build \
		-t $(REPOSITORY):$(TAG) \
		--platform linux/amd64,linux/arm64 \
		-f Dockerfile .
.PHONY: buildx
