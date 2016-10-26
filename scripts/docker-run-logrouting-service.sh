#!/bin/sh

docker run --name ${SVC_CONTAINER_NAME} \
    -e CERTIFICATE="${CERT}" \
	-e KEY="${KEY}" \
	-p ${PORT}:8080 \
	-w "/logserv" \
	-d ${SVC_IMAGE_NAME}:${SVC_IMAGE_TAG}