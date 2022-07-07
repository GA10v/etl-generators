PROJECT_DIR = $(dir $(abspath $(firstword $(MAKEFILE_LIST))))
VENV = .venv
PYTHON = $(VENV)/bin/python

.PHONY: install
install:
	@echo 'Installing python dependencies...'
	@poetry install
	@echo 'Installing and updating pre-commit...'
	@pre-commit install
	@pre-commit autoupdate

.PHONY: pip-to-global
pip-to-global:
	echo "[global]\nindex-url = https://pypi.org/simple" > .venv/pip.conf

.PHONY: format
format:
	@pre-commit run --all

.PHONY: docker-start-postgres
docker-start-postgres:
	@docker run -d \
	--name etl-generators-postgres -p 6437:5432 \
	-e POSTGRES_PASSWORD=123qwe \
	-e POSTGRES_USER=app \
	-e POSTGRES_DB=etl-generators \
	postgres:13

.PHONY: docker-stop-postgres
docker-stop-postgres:
	@docker stop etl-generators-postgres
	@docker rm etl-generators-postgres

.PHONY: jupyter
jupyter:
	@export PYTHONPATH=$(PROJECT_DIR)src/
	@$(PYTHON) -m jupyter notebook --no-browser --notebook-dir=src/
