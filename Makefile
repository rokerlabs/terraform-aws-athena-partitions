GO_IMAGE = golang:1.16
NODE_IMAGE = node:14

export BUILDKITE = false

.PHONY: terraform-docs

all: clean init lint security-check terraform-fmt terraform-validate terraform-docs build clean

build:
	docker run --rm -t -e BUILDKITE -v $(shell pwd)/:/workdir -w /workdir ${GO_IMAGE} .buildkite/bin/build

clean:
	rm -rf .terraform/ dist/ node_modules/ yarn.lock cover.out .terraform.lock.hcl

init:
	docker run --rm -t -v $(shell pwd)/:/workdir -w /workdir ${NODE_IMAGE} yarn install

lint:
	docker run --rm -t -v $(shell pwd)/:/workdir -w /workdir wata727/tflint --var-file=testing.tfvars .
	.buildkite/bin/lint
	docker run --rm -t -e BUILDKITE -v $(shell pwd)/:/workdir -w /workdir ${NODE_IMAGE} .buildkite/bin/commitlint

security-check:
	docker run --rm -t -v $(shell pwd)/:/workdir -w /workdir tfsec/tfsec --tfvars-file=testing.tfvars .
	docker run --rm -t -v $(shell pwd):/workdir bridgecrew/checkov -d /workdir

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