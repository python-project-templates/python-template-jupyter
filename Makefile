#########
# BUILD #
#########
.PHONY: develop build-py build-js build install serverextension labextension

develop:  ## install dependencies and build library
	python -m pip install -e .[develop]
	cd js; yarn

build-py:  ## build the python library
	python -m build .

build-js:  ## build javascript
	cd js; yarn build

build: build-py build-js  ## build the library


install:  ## install library
	python -m pip install .
serverextension: install ## enable the jupyter server extension
	python -m jupyter server extension enable --py jupyter_template

labextension: js ## build and install the labextension
	cd js; python -m jupyter labextension install .

#########
# LINTS #
#########
.PHONY: lint-py lint-js lint-cpp lint  lints fix-py fix-js fix-cpp fix format

lint-py:  ## run python linter with flake8 and black
	python -m ruff jupyter_template setup.py
	python -m black --check jupyter_template setup.py
lint-js:  ## run javascript linter with eslint
	cd js; yarn lint

lint: lint-py lint-js  ## run all lints

# Alias
lints: lint

fix-py:  ## fix python formatting with black
	python -m black jupyter_template/ setup.py
	python -m ruff jupyter_template/ setup.py --fix

fix-js:  ## fix javascript formatting with eslint
	cd js; yarn fix

fix: fix-py fix-js  ## run all autofixers

# alias
format: fix

################
# Other Checks #
################
.PHONY: check-manifest semgrep checks check annotate

check-manifest:  ## check python sdist manifest with check-manifest
	check-manifest -v

semgrep:  ## check for possible errors with semgrep
	semgrep ci --config auto

checks: check-manifest semgrep

# Alias
check: checks

annotate:  ## run python type annotation checks with mypy
	python -m mypy ./jupyter_template

#########
# TESTS #
#########
.PHONY: test-py test-js coverage-py test coverage tests

test-py:  ## run python tests
	python -m pytest -v jupyter_template/tests --junitxml=junit.xml

test-js: ## run javascript tests
	cd js; yarn test
coverage-py:  ## run tests and collect test coverage
	python -m pytest -v jupyter_template/tests --junitxml=junit.xml --cov=jupyter_template --cov-branch --cov-fail-under=75 --cov-report term-missing --cov-report xml

test: test-py test-js ## run all tests

coverage: coverage-py test-js  ## run all tests with coverage collection

# Alias
tests: test

########
# DOCS #
########
.PHONY: docs show-docs

docs:  ## build html documentation
	make -C ./docs html

show-docs:  ## show docs with running webserver
	cd ./docs/_build/html/ && PYTHONBUFFERED=1 python -m http.server | sec -u "s/0\.0\.0\.0/$$(hostname)/g"

###########
# VERSION #
###########
.PHONY: show-version patch minor major

show-version:  ## show current library version
	bump2version --dry-run --allow-dirty setup.py --list | grep current | awk -F= '{print $2}'

patch:  ## bump a patch version
	bump2version patch

minor:  ## bump a minor version
	bump2version minor

major:  ## bump a major version
	bump2version major

########
# DIST #
########
.PHONY: dist-py dist-py-sdist dist-py-local-wheel publish-py publish-js publish

dist-py:  # build python dists
	python setup.py sdist bdist_wheel

dist-check:  ## run python dist checker with twine
	python -m twine check dist/*

dist: clean build dist-py dist-check  ## build all dists

publish-py:  # publish python assets
	python -m twine upload dist/* --skip-existing

publish-js:  ## pulbish javascript assets
	cd js; npm publish || echo "can't publish - might already exist"

publish: dist publish-py publish-js  ## publish dists

#########
# CLEAN #
#########
.PHONY: deep-clean clean

deep-clean: ## clean everything from the repository
	git clean -fdx

clean: ## clean the repository
	rm -rf .coverage coverage cover htmlcov logs build dist *.egg-info
	rm -rf js/lib js/dist jupyter_template/labextension jupyter_template/nbextension

############################################################################################

.PHONY: help

# Thanks to Francoise at marmelab.com for this
.DEFAULT_GOAL := help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

print-%:
	@echo '$*=$($*)'
