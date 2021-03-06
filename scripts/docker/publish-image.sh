#!/bin/sh

if [ -z ${DOCKER_REPOSITORY} ]; then
	echo "Cannot push images as DOCKER_REPOSITORY is not set"
	echo "if you want to push this to local docker registry use"
	echo "${WARN_MAGENTA} export DOCKER_REPOSITORY=localhost:5000${NO_COLOR}"
	echo ""
	echo "if you want to push this to cnap shared docker registry use"
	echo "${WARN_MAGENTA} export DOCKER_REPOSITORY=docker-registry.helion.space:443${NO_COLOR}"
	exit 1
fi

if [ -z ${IMAGE_NAME} ]; then
	echo "Error: Please set value for environemtn variable SIDECAR_IMAGE_NAME"
	exit 1
fi

if [ -z ${IMAGE_TAG} ]; then
	echo "Error: Please set value for environemtn variable SIDECAR_IMAGE_TAG"
	exit 1
fi

if [ -z ${DOCKER_ORGANIZATION} ]; then
	echo "Error: Please set value for environemtn variable DOCKER_ORGANIZATION"
	exit 1
fi

docker images ${SVC_IMAGE_NAME} | grep ${IMAGE_TAG} > /dev/null
if [ $? -eq 0 ]; then
	docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${DOCKER_REPOSITORY}/${DOCKER_ORGANIZATION}/${IMAGE_NAME}:${IMAGE_TAG}
	docker push ${DOCKER_REPOSITORY}/${DOCKER_ORGANIZATION}/${IMAGE_NAME}:${IMAGE_TAG}
else
	echo "Error: Docker image ${SVC_IMAGE_NAME}:${IMAGE_TAG} not found"
	echo "Before running publish-image, please use 'make build-image' to build the docker image."
	exit 1
fi
