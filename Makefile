#!make
PWD := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

PROJECT=connectapi
NETWORK=${PROJECT}_default
CONNECT_VERSION=2024.03.0

#---------------------------------------------
# Network
#---------------------------------------------
network-up:
	$(eval NETWORK_EXISTS=$(shell docker network inspect ${NETWORK} > /dev/null 2>&1 && echo 0 || echo 1))
	@if [ "${NETWORK_EXISTS}" = "1" ] ; then \
		echo "Creating network: ${NETWORK}"; \
		docker network create --driver bridge ${NETWORK} ; \
	fi;

network-down:
	$(eval NETWORK_EXISTS=$(shell docker network inspect ${NETWORK} > /dev/null 2>&1 && echo 0 || echo 1))
	@if [ "${NETWORK_EXISTS}" = "0" ] ; then \
		for i in `docker network inspect -f '{{range .Containers}}{{.Name}} {{end}}' ${NETWORK}`; do \
			echo "Removing container \"$${i}\" from network \"${NETWORK}\""; \
			docker network disconnect -f ${NETWORK} $${i}; \
		done; \
		echo "Removing network: ${NETWORK}"; \
		docker network rm ${NETWORK}; \
	fi;

#---------------------------------------------
# Update versions
#---------------------------------------------
update-versions:
	@sed -i '' "s/CONNECT_VERSION\:.*/CONNECT_VERSION: ${CONNECT_VERSION}/g" .github/workflows/pkgdown.yaml
	@sed -i '' "s/CONNECT_VERSION\:.*/CONNECT_VERSION: ${CONNECT_VERSION}/g" .github/workflows/test-coverage.yaml
	@sed -i '' "s/CONNECT_VERSION\:.*/CONNECT_VERSION: ${CONNECT_VERSION}/g" .github/workflows/pr-commands.yaml
	@sed -i '' "s/^current_connect_version <- .*/current_connect_version <- '${CONNECT_VERSION}'/g" R/connectapi.R

#---------------------------------------------
# Helpers
#---------------------------------------------
mail-up:
	NETWORK=${NETWORK} \
	docker compose -f .github/local/mail.yml -f .github/local/make-network.yml up -d

mail-down:
	NETWORK=${NETWORK} \
	docker compose -f .github/local/mail.yml -f .github/local/make-network.yml down

connect-up:
	NETWORK=${NETWORK} \
	RSC_LICENSE=$(RSC_LICENSE) \
	CONNECT_VERSION=$(CONNECT_VERSION) \
	docker compose -f inst/ci/test-connect.yml -f .github/local/make-network.yml up -d

connect-down:
	NETWORK=${NETWORK} \
	docker compose -f inst/ci/test-connect.yml -f .github/local/make-network.yml down

connect-file-up:
	NETWORK=${NETWORK} \
	RSC_LICENSE=$(RSC_LICENSE) \
	CONNECT_VERSION=$(CONNECT_VERSION) \
	docker compose -f inst/ci/test-connect-lic.yml -f .github/local/make-network.yml up -d

connect-file-down:
	NETWORK=${NETWORK} \
	docker compose -f inst/ci/test-connect-lic.yml -f .github/local/make-network.yml down

test-env-up:
	NETWORK=${NETWORK} \
	RSC_LICENSE=$(RSC_LICENSE) \
	CONNECT_VERSION=$(CONNECT_VERSION) \
	docker compose -f .github/local/test-connect-ci.yml -f .github/local/make-network.yml up -d

test-env-down:
	NETWORK=${NETWORK} \
	docker compose -f .github/local/test-connect-ci.yml -f .github/local/make-network.yml down

test-run:
	NETWORK=${NETWORK} \
  docker compose -f .github/local/test.yml -f .github/local/make-network.yml run test

test-run-i:
	NETWORK=${NETWORK} \
  docker compose -f .github/local/test.yml -f .github/local/make-network.yml run test bash

test: network-up test-env-up test-run test-env-down network-down

clean: test-env-down network-down
