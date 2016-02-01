IMAGE_NAME = rickr/agileup
TUTUM_IMAGE_NAME = tutum.co/rickr/agileup:latest

all: build deploy

build:
	docker build -t $(IMAGE_NAME) .


deploy:
	docker tag $(IMAGE_NAME):latest $(TUTUM_IMAGE_NAME)
