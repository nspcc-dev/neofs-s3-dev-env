#!/usr/bin/make -f
SHELL = bash

# Main environment configuration
include .env

# help target
include help.mk

# Services
SVCS = $(shell cat .services | grep -v \\\#)
STOP_SVCS = $(shell tac .services | grep -v \\\#)

# Tests
# Prepare tests
prepare.tests:
	@./bin/prepareTests.sh

# Remove config
clean.config:
	@rm -rf services/*/s3tests.conf

# Remove all temp files
clean: clean.config
	@rm -rf vendor tests

# S3 GW
# Form config for testing of NeoFS S3 GW
prepare.s3-gw:
	@echo "Forming s3-gw s3tests.conf"
	@./services/s3-gw/formConf.sh

# Run tests on NeoFS S3 GW, set TEST variable via appending `TEST=path-to-test` to run tests from a specific file or a specific test
TEST=""
tests.s3-gw: prepare.tests prepare.s3-gw
	@./bin/runTests.sh services/s3-gw/s3tests.conf $(TEST)


# Services
# minio
# Form config for testing of minio
prepare.minio:
	@echo "Forming s3tests.conf"
	@./services/minio/formConf.sh

# Run tests on minio
tests.minio: prepare.tests prepare.minio
	@./bin/runTests.sh services/minio/s3tests.conf

# Up services
up: pull vendor/hosts
	$(foreach SVC, $(SVCS), $(shell docker-compose -f services/$(SVC)/docker-compose.yml up -d))

# Stop services
down:
	$(foreach SVC, $(STOP_SVCS), $(shell docker-compose -f services/$(SVC)/docker-compose.yml down -v))

# Pull docker images of services
pull:
	$(foreach SVC, $(SVCS), $(shell cd services/$(SVC) && docker-compose pull))
	@:

# Hosts
# Display changes for /etc/hosts
hosts: vendor/hosts
	@cat vendor/hosts

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
