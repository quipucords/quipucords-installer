.PHONY: help all lint
.DEFAULT_GOAL := help

help: ## show this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

all: lint ## run all targets (lint)

lint: ## lint check the shell scripts
	@shellcheck ./bin/*
	@shfmt -i 2 --diff ./bin/*
