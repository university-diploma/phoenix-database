SHELL := /bin/bash
DOCKER ?= docker
IMAGE_NAME := 'phoenix-database'
CONTAINER_NAME := 'phoenix-db'
USERNAME := 'bsgfb'

DOCKER_BUILD := ${DOCKER} build -t ${IMAGE_NAME} .
DOCKER_RUN := ${DOCKER} run -it --rm --name ${CONTAINER_NAME} -p 3306:3306 -d ${IMAGE_NAME}

build:
	${DOCKER_BUILD}

run:
	${DOCKER_RUN}

full:
	${DOCKER_BUILD}
	${DOCKER_RUN}

stop:
	${DOCKER} stop ${CONTAINER_NAME}

push:
	${DOCKER_BUILD}
	${DOCKER} tag ${IMAGE_NAME} ${USERNAME}/${IMAGE_NAME}
	${DOCKER} push ${USERNAME}/${IMAGE_NAME}
