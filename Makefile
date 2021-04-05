GITHUB_LATEST_VERSION=$(shell curl https://api.github.com/repos/GoMetric/statsd-http-proxy/releases/latest 2>/dev/null | grep tag_name | awk -F'"' '{print $$4}')

default: docker-build

# to publish to docker registry we need to be logged in
docker-login:
    ifdef DOCKER_REGISTRY_USERNAME
		@echo "h" $(DOCKER_REGISTRY_USERNAME) "h"
    else
		docker login
    endif

# build docker images
docker-build:
	@echo "Building docker image version: " $(GITHUB_LATEST_VERSION)
	docker build \
		--tag gometric/statsd-http-proxy:latest \
		--tag gometric/statsd-http-proxy:$(GITHUB_LATEST_VERSION) \
		--build-arg VERSION=$(GITHUB_LATEST_VERSION) \
		-f ./Dockerfile.alpine .

# publish docker images to hub
docker-publish: docker-login
	docker login
	docker push gometric/statsd-http-proxy:latest
	docker push gometric/statsd-http-proxy:$(GITHUB_LATEST_VERSION)