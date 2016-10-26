NO_COLOR=\033[0m
OK_COLOR=\033[32;01m
OK_GREEN_COLOR=\033[32;01m
ERROR_COLOR=\033[31;01m
WARN_CYN_COLOR=\033[33;01m

export SERVICE_ROOT:=${GOPATH}/src/github.com/hpcloud/logging-route-service

export SVC_IMAGE_NAME:=hsm-sidecar-dev-logrouting-service
export SVC_IMAGE_TAG:=latest
export SVC_CONTAINER_NAME:=sidecar-dev-logrouting-docker-host
export PORT:=50000


.PHONY: clean-all clean build-image run test

default: help

help:
	@echo "These 'make' targets are available."
	@echo
	@echo "  all                  cleans existing container and images and then"
	@echo "                       build docker image and runs the container "
	@echo "  build                build the extension binary"
	@echo "  run                  run the docker container for service"
	@echo "  test-format          Run the formatting tests"
	@echo "  test                 Run the formatting tests"
	@echo "  clean-containers     Remove all docker containers for extension"
	@echo "  clean-images         Remove all docker images for extension"
	@echo "  clean-all            Remove docker container and images"
	@echo "  build-image          Build service docker image"
	@echo "  publish-image        Publish service docker image to registry"
	@echo

all:	clean-all build-image run

build:
	${SERVICE_ROOT}/scripts/build.sh

run:
	@echo "$(OK_COLOR)==> Run image $(NO_COLOR)"
	${SERVICE_ROOT}/scripts/docker-run-logrouting-service.sh

test-format:
	@(echo "$(OK_COLOR)==> Running gofmt $(NO_COLOR)";\
	FILES=`find . -name "*.go" | grep -v vendor | grep -v Godeps`;\
	${SERVICE_ROOT}/scripts/testFmt.sh "$$FILES")
		
# (required) run tests
test:	test-format
	@(export GO15VENDOREXPERIMENT=1; \
	go list ./... | grep -v vendor | go test -v)

# (required) clean containers
clean-containers:
	${SERVICE_ROOT}/scripts/docker/remove-docker-container.sh ${SVC_IMAGE_NAME}
	
# (required) clean docker images
clean-images:
	${SERVICE_ROOT}/scripts/docker/remove-docker-image.sh ${SVC_IMAGE_NAME}
	
# (required) clean docker containers and images
clean-all:	clean-containers clean-images

# (required) build docker image for service
build-image:	
	@echo "$(OK_COLOR)==> Building Docker image $(NO_COLOR)"
	${SERVICE_ROOT}/scripts/build-service.sh

# (required) push image to docker registry
publish-image:
	IMAGE_NAME=${SVC_IMAGE_NAME} IMAGE_TAG=${SVC_IMAGE_TAG} ${SERVICE_ROOT}/scripts/docker/publish-image.sh
	
