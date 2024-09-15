#########
# BUILD #
#########
.PHONY: develop-py develop-js develop
develop-py:
	python -m pip install -e .[develop]

develop-js:
	cd js; pnpm install && npx playwright install

develop: develop-js develop-py  ## setup project for development

.PHONY: build-py build-js build
build-py:
	python setup.py build build_ext --inplace

build-js:
	cd js; pnpm build

build: build-js build-py  ## build the project

.PHONY: install
install:  ## install python library
	python -m pip install .

#########
# LINTS #
#########
.PHONY: lint-py lint-js lint lints
lint-py:  ## run python linter with ruff
	python -m ruff check jupyter_template
	python -m ruff format --check jupyter_template

lint-js:  ## run js linter
	cd js; pnpm lint

lint: lint-js lint-py  ## run project linters

# alias
lints: lint

.PHONY: fix-py fix-js fix format
fix-py:  ## fix python formatting with ruff
	python -m ruff check --fix jupyter_template
	python -m ruff format jupyter_template

fix-js:  ## fix js formatting
	cd js; pnpm fix

fix: fix-js fix-py  ## run project autoformatters

# alias
format: fix

################
# Other Checks #
################
.PHONY: check-manifest checks check annotate

check-manifest:  ## check python sdist manifest with check-manifest
	check-manifest -v

checks: check-manifest

# alias
check: checks

annotate:  ## run python type annotation checks with mypy
	python -m mypy ./jupyter_template

#########
# TESTS #
#########
.PHONY: test-py tests-py coverage-py
test-py:  ## run python tests
	python -m pytest -v jupyter_template/tests --junitxml=junit.xml

# alias
tests-py: test-py

coverage-py:  ## run python tests and collect test coverage
	python -m pytest -v jupyter_template/tests --junitxml=junit.xml --cov=jupyter_template --cov-branch --cov-fail-under=50 --cov-report term-missing --cov-report xml

.PHONY: test-js tests-js coverage-js
test-js:  ## run js tests
	cd js; pnpm test

# alias
tests-js: test-js

coverage-js: test-js  ## run js tests and collect test coverage

.PHONY: test coverage tests
test: test-py test-js  ## run all tests
coverage: coverage-py coverage-js  ## run all tests and collect test coverage

# alias
tests: test

###########
# VERSION #
###########
.PHONY: show-version patch minor major

show-version:  ## show current library version
	@bump-my-version show current_version

patch:  ## bump a patch version
	@bump-my-version bump patch

minor:  ## bump a minor version
	@bump-my-version bump minor

major:  ## bump a major version
	@bump-my-version bump major

########
# DIST #
########
.PHONY: dist dist-build dist-sdist dist-local-wheel publish

dist-build-py:  # build python dists
	python -m build -w -s

dist-build-js:  # build js dists
	cd js; pnpm pack

dist-check:  ## run python dist checker with twine
	python -m twine check dist/*

dist: clean build dist-build-js dist-build-py dist-check  ## build all dists

publish: dist  # publish python assets

#########
# CLEAN #
#########
.PHONY: deep-clean clean

deep-clean: ## clean everything from the repository
	git clean -fdx

clean: ## clean the repository
	rm -rf .coverage coverage cover htmlcov logs build dist *.egg-info

############################################################################################

.PHONY: help

# Thanks to Francoise at marmelab.com for this
.DEFAULT_GOAL := help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

print-%:
	@echo '$*=$($*)'
