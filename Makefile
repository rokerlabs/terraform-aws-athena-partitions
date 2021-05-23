# Default to not printing commands Add VERBOSE=on to the command line to see commands
$(VERBOSE).SILENT:
.PHONY: $(VERBOSE).SILENT

export BUILDKITE = false

.PHONY:

all: clean install lint security-check terraform-fmt terraform-validate build clean

build:
	docker run --rm -t -e BUILDKITE -v $(shell pwd)/:/workdir -w /workdir golang:1.16 .buildkite/bin/build

clean:
	rm -rf .terraform/ dist/ node_modules/ yarn.lock cover.out .terraform.lock.hcl

docs:
	.buildkite/bin/terraform-docs

install:
	yarn install

lint:
	docker run --rm -t -v $(shell pwd)/:/workdir -w /workdir wata727/tflint --var-file=testing.tfvars .
	.buildkite/bin/lint
	.buildkite/bin/commitlint

security-check:
	docker run --rm -t -v $(shell pwd)/:/workdir -w /workdir tfsec/tfsec --tfvars-file=testing.tfvars .
	docker run --rm -t -v $(shell pwd):/workdir bridgecrew/checkov -d /workdir

terraform-fmt:
	terraform fmt

terraform-validate:
	terraform init
	AWS_REGION=us-west-2 terraform validate

test:
	.buildkite/bin/test