# Main Makefile

PROJECT?=antia
APPS?=$(shell ls -d cmd/*/ | sed "s@cmd/@@g;s@/@@g")

ROOT_DIR=$$(pwd)
GOFMT_FILES?=$$(find . -name '*.go')
INSTALL_DIR?=/tmp/deploy/$(PROJECT)
LOG_DIR?=/var/log/$(PROJECT)

DEFAULT: build

build:
	@$(foreach APP, $(APPS), PROJECT=$(PROJECT) APP=$(APP) BIN_RELEASE=1 sh -c "'$(CURDIR)/scripts/build.sh'";)

buildrace:
	@$(foreach APP, $(APPS), PROJECT=$(PROJECT) APP=$(APP) RACE=-race CGO_ENABLED=1 sh -c "'$(CURDIR)/scripts/build.sh'";)

conf:
	@sh -c "'$(CURDIR)/scripts/build_conf.sh'"

clean:
	@sh -c "'$(CURDIR)/scripts/clean.sh'"

fmt:
	gofmt -w $(GOFMT_FILES)

install:
	@$(foreach APP, $(APPS), PROJECT=$(PROJECT) ABS_INSTALL_TO=$(INSTALL_DIR) APP=$(APP) sh -c "'$(CURDIR)/scripts/install.sh'";)

deploy: build install clean

deployrace: buildrace install clean

run:
	@ABS_INSTALL_TO=${INSTALL_DIR} ABS_LOG_TO=${LOG_DIR} sh -c "'$(CURDIR)/scripts/local.sh'"

local: deploy run

localrace: deployrace run

test: deployrace
	@ABS_INSTALL_TO=${INSTALL_DIR} ABS_LOG_TO=${LOG_DIR} RUN_ENV=test DB_NAME=${PROJECT}_test CREATE_DB_SQL=${ROOT_DIR}/test/sql/database_test.sql sh -c "'$(CURDIR)/scripts/test.sh'"

cover:
	@go tool cover 2>/dev/null; if [ $? -eq 3 ]; then \
		go get -u golang.org/x/tools/cmd/cover; \
	fi
	go test ./test/testcases/... -coverprofile=coverage.out
	go tool cover -html=coverage.out
	rm coverage.out

generate:
	go generate ./...

.NOTPARALLEL:

.PHONY: build \
	buildrace \
	conf \
	clean \
	fmt \
	install \
	deploy \
	deployrace \
	local \
	localrace \
	test \
	cover \
	generate
