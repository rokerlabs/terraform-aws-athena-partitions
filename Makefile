.PHONY: terraform-docs

all: clean init lint security-check terraform-fmt terraform-validate terraform-docs build clean

build:
	.buildkite/bin/build

clean:
	rm -rf .terraform/ dist/ node_modules/ yarn.lock cover.out

init:
	yarn install

lint:
	tflint .
	.buildkite/bin/commitlint

security-check:
	@tfsec .

terraform-docs:
	@sed '/generated-docs-below/q' README.md | tee README.md
	@terraform-docs md . >> README.md
	@echo "\n## Copyright\n\nCopyright (c) 2021 Roker Labs. See [LICENSE](./LICENSE) for details." >> README.md

terraform-fmt:
	terraform fmt

terraform-validate:
	terraform init
	AWS_REGION=us-west-2 terraform validate

test:
	.buildkite/bin/test