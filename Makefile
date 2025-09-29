.PHONY: run test format lint

SHELL := /bin/bash

run:
./scripts/dev.sh run

test:
./scripts/dev.sh test

format:
./scripts/dev.sh format

lint: format
@echo "Linting is handled by pre-commit hooks in this template."
