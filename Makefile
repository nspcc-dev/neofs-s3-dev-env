#!/usr/bin/make -f
SHELL = bash

# Main environment configuration
include .env

# help target
include help.mk

# Targets to get required artifacts and external resources for each service
-include services/*/artifacts.mk

# Targets helpful to prepare service environment
-include services/*/prepare.mk

# Services that require artifacts
GET_SVCS = $(shell grep -Rl "get.*:" ./services/* | sort -u | grep artifacts.mk | xargs -I {} dirname {} | xargs -I {} basename -a {})

# Services that require pulling images
PULL_SVCS = $(shell cat .services | grep -v \\\#)

# List of services to run
START_SVCS = $(shell cat .services | grep -v \\\#)
STOP_SVCS = $(shell tac .services | grep -v \\\#)

# List of hosts available in devenv
HOSTS_SVCS = $(shell tac .services | grep -v \\\#)

up: pull get vendor/hosts
	$(foreach SVC, $(START_SVCS), $(shell docker-compose -f services/$(SVC)/docker-compose.yml up -d))

# Stop environment
down:
	$(foreach SVC, $(STOP_SVCS), $(shell docker-compose -f services/$(SVC)/docker-compose.yml down -v))

# Pull all required Docker images
pull:
	$(foreach SVC, $(PULL_SVCS), $(shell cd services/$(SVC) && docker-compose pull))
	@:

# Get all services artifacts
get: $(foreach SVC, $(GET_SVCS), get.$(SVC))
	@:

vendor/hosts:
	@mkdir -p ./vendor
	@echo "# s3 services:" > $@
	@for service in $(HOSTS_SVCS); do \
		file="services/$${service}/.hosts"; \
		[[ -r "$${file}" ]] && \
		while read h; do \
			echo $${h}| sed 's|IPV4_PREFIX|$(IPV4_PREFIX)|g' | sed 's|LOCAL_DOMAIN|$(LOCAL_DOMAIN)|g' \
			                                                 | sed 's|NEOFS_DOMAIN|$(NEOFS_DOMAIN)|g'; \
		done < $${file}; \
	done >> $@

# Display changes for /etc/hosts
hosts: vendor/hosts
	@cat vendor/hosts

# Clean-up the environment
clean:
	@rm -rf vendor tests services/*/s3tests.conf

# Prepare tests
prepare.tests:
	@./bin/prepareTests.sh

tests.minio: prepare.tests prepare.minio
	@./bin/runTests.sh services/minio/s3tests.conf

tests.s3-gw: prepare.tests prepare.s3-gw
	@./bin/runTests.sh services/s3-gw/s3tests.conf
