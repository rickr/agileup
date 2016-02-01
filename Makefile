IMAGE_NAME = rickr/agileup
TUTUM_IMAGE_NAME = tutum.co/rickr/agileup
VERSION = $(shell cat version)

all: build deploy

build:
	docker build -t $(IMAGE_NAME) .
	docker tag $(IMAGE_NAME):latest $(IMAGE_NAME):$(VERSION)

deploy:
	docker tag $(IMAGE_NAME):$(VERSION) $(TUTUM_IMAGE_NAME):$(VERSION)
	docker push $(TUTUM_IMAGE_NAME)
