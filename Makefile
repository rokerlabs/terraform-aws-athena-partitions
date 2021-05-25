# Default to not printing commands Add VERBOSE=on to the command line to see commands
$(VERBOSE).SILENT:
.PHONY: $(VERBOSE).SILENT docs

export BUILDKITE = false

all: clean install lint test security-check terraform-fmt terraform-validate build clean

build:
	docker run --rm -t -e BUILDKITE -v $(shell pwd)/:/workdir -w /workdir golang:1.16 .buildkite/bin/build

clean:
	rm -rf .terraform/ dist/ node_modules/ yarn.lock cover.out .terraform.lock.hcl

docs:
	sed -i '' '/generated-docs-below/q' README.md
	terraform-docs md . >> README.md
	printf "\n## Copyright\n\nCopyright (c) 2021 Roker Labs. See [LICENSE](./LICENSE) for details." >> README.md

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