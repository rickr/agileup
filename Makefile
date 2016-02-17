IMAGE_NAME = rickr/agileup
DOCKER_IMAGE_NAME = rickr/agileup:web
VERSION = $(shell cat version)

all: build deploy

build:
	docker build -t $(IMAGE_NAME) .
	docker tag -f $(IMAGE_NAME):latest $(IMAGE_NAME):$(VERSION)

deploy:
	docker tag -f $(IMAGE_NAME):$(VERSION) $(DOCKER_IMAGE_NAME)
	docker push $(DOCKER_IMAGE_NAME)
