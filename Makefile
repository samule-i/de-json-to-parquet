#################################################################################
#
# Makefile to build the project
#
#################################################################################

PROJECT_NAME = de-json-to-parquet
REGION = eu-west-2
PYTHON_INTERPRETER = python
WD=$(shell pwd)
PYTHONPATH=${WD}
SHELL := /bin/bash
PROFILE = default
PIP:=pip

## Create python interpreter environment.
create-environment:
	@echo ">>> About to create environment: $(PROJECT_NAME)..."
	@echo ">>> check python3 version"
	( \
		$(PYTHON_INTERPRETER) --version; \
	)
	@echo ">>> Setting up VirtualEnv."
	( \
	    $(PIP) install -q virtualenv virtualenvwrapper; \
	    virtualenv .venv --python=$(PYTHON_INTERPRETER); \
	)

# Define utility variable to help calling Python from the virtual environment
ACTIVATE_ENV := source .venv/bin/activate

# Execute python related functionalities from within the project's environment
define execute_in_env
	$(ACTIVATE_ENV) && $1
endef

## Build the environment requirements
requirements: create-environment
	$(call execute_in_env, $(PIP) install -r ./requirements.txt)


################################################################################################################
# Set Up
bandit:
	$(call execute_in_env, $(PIP) install bandit)
safety:
	$(call execute_in_env, $(PIP) install safety)
flake:
	$(call execute_in_env, $(PIP) install flake8)
coverage:
	$(call execute_in_env, $(PIP) install coverage)

## Set up dev requirements (bandit, safety, flake8)
dev-setup: bandit safety flake coverage

security-test:
	$(call execute_in_env, safety check -r ./requirements.txt)
	$(call execute_in_env, bandit -lll */*.py *c/*/*.py)

run-flake:
	$(call execute_in_env, flake8  ./src/*/*.py ./test/*/*.py)

unit-test:
	$(call execute_in_env, PYTHONPATH=${PYTHONPATH} pytest -v)

check-coverage:
	$(call execute_in_env, PYTHONPATH=${PYTHONPATH} coverage run --omit 'venv/*' -m pytest && coverage report -m)

## Run all checks
run-checks: security-test run-flake unit-test check-coverage
