# Developing Athena Partitions

* [Development Setup](#setup)
* [Running Tests](#tests)
* [Coding Rules](#rules)
* [Commit Message Guidelines](#commits)
* [Writing Documentation](#documentation)

## <a name="setup"> Development Setup

This document describes how to set up your development environment to build and test Athena Partitions, and
explains the basic mechanics of using `git`, `go`, `yarn`, `terraform` etc...

### Installing Dependencies

Before you can build Athena Partitions, you must install and configure the following dependencies on your
machine:

* [Git](http://git-scm.com/): The [Github Guide to Installing Git][git-setup] is a good source of information.

* [Node.js (LTS)](http://nodejs.org): We use Node to generate the documentation and generate
  distributable files. Depending on your system, you can install Node either from source or as a
  pre-packaged bundle.

* [Yarn](https://yarnpkg.com): We use Yarn to install our Node.js module dependencies
  (rather than using npm). See the detailed [installation instructions][yarn-install].

* [Terraform](https://www.terraform.io): We use Terraform to format and validate our HCL configuration code.
  See the official [official download instructions][terraform-download] or install with `brew install terraform`.

* [Docker](https://www.docker.com): We use Docker to run tools such as TFLint, TFSEC and checkov to check for
  possible Terraform errors and best practices. See the detailed [installation instructions][docker-install].

### Set up

Simply run the following make command to configure you local dev environment:

```shell
make install
```

## <a name="tests"> Running Tests

### <a name="unit-tests"></a> Running the Unit Test Suite

We write unit and integration tests.

```shell
make test
```

### <a name="e2e-tests"></a> Running the End-to-end Test Suite

Athena Partitions's end to end tests are run with Cypress. Simply run:

```shell
make all
```

This will build, test, lint and run static code analysis.

## <a name="rules"></a> Coding Rules

To ensure consistency throughout the source code, keep these rules in mind as you are working:

* All features or bug fixes **must be tested** by one or more tests.

### Specific topics

## <a name="commits"></a> Git Commit Guidelines

We follow v1.0.0 of the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/#summary)
specification for commit message formatting. This leads to **more readable messages** that are easy to
follow when looking through the **project history**.

We also use the git commit messages to **generate the Athena Partitions change log**.

The commit message formatting can be added using a typical git workflow or through the use of a CLI
wizard ([Commitizen](https://github.com/commitizen/cz-cli)). Alternatively you can simply run the
`make install` command to install husky with the commitizen cli pre-commit hook.

### Commit Message Format
Each commit message consists of a **header**, a **body** and a **footer**.  The header has a special
format that includes a **type**, a **scope** and a **subject**:

```
<type>(<scope>): <subject>
<BLANK LINE>
<body>
<BLANK LINE>
<footer>
```

The **header** is mandatory and the **scope** of the header is optional.

Any line of the commit message cannot be longer than 100 characters! This allows the message to be easier
to read on GitHub as well as in various git tools.

### Revert
If the commit reverts a previous commit, it should begin with `revert: `, followed by the header
of the reverted commit.
In the body it should say: `This reverts commit <hash>.`, where the hash is the SHA of the commit
being reverted.

### Type
Must be one of the following:

* **build**: Changes that affect the build system or external dependencies (example scopes: gulp, broccoli, npm)
* **ci**: Changes to our CI configuration files and scripts (example scopes: Travis, Circle, BrowserStack, SauceLabs)
* **docs**: Documentation only changes
* **feat**: A new feature
* **fix**: A bug fix
* **perf**: A code change that improves performance
* **refactor**: A code change that neither fixes a bug nor adds a feature
* **style**: Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
* **test**: Adding missing tests or correcting existing tests

### Scope

The scope could be anything specifying place of the commit change.

### Subject
The subject contains succinct description of the change:

* use the imperative, present tense: "change" not "changed" nor "changes"
* don't capitalize first letter
* no dot (.) at the end

### Body
Just as in the **subject**, use the imperative, present tense: "change" not "changed" nor "changes".
The body should include the motivation for the change and contrast this with previous behavior.

### Footer
The footer should contain any information about **Breaking Changes** and is also the place to
[reference GitHub issues that this commit closes][closing-issues].

**Breaking Changes** should start with the word `BREAKING CHANGE:` with a space or two newlines.
The rest of the commit message is then used for this.

A detailed explanation can be found in this [document][commit-message-format].

## <a name="documentation"></a> Writing Documentation

### Building and viewing the README locally
The docs can be built from scratch using make:

```shell
make docs
```

### General documentation with Markdown

Any text in tags can contain markdown syntax for formatting. Generally, you can use any markdown
feature.

#### Headings

Only use *h2* headings and lower, as the page title is set in *h1*. Also make sure you follow the
heading hierarchy. This ensures correct table of contents are created.

#### Code blocks
In line code can be specified by enclosing the code in back-ticks (\`).
A block of multi-line code can be enclosed in triple back-ticks (\`\`\`) but it is formatted better
if it is enclosed in &lt;pre&gt;...&lt;/pre&gt; tags and the code lines themselves are indented.

[closing-issues]: https://help.github.com/articles/closing-issues-via-commit-messages/
[commit-message-format]: https://docs.google.com/document/d/1QrDFcIiPjSLDn3EL15IJygNPiHORgU1_OOAqWjiDU5Y/edit#
[git-setup]: https://help.github.com/articles/set-up-git
[terraform-download]: https://www.terraform.io/downloads.html
[docker-install]: https://www.docker.com/products/docker-desktop
[yarn-install]: https://yarnpkg.com/en/docs/install
