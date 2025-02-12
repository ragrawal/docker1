# Usage: make setup
# Description: Installs the specified versions of Python and Poetry using asdf, and installs project dependencies with Poetry.
# Requires: .tool-versions file with specified Python and Poetry versions.
setup:
	asdf plugin-add python
	asdf plugin-add poetry https://github.com/asdf-community/asdf-poetry.git
	asdf install
	poetry self add poetry-dotenv-plugin	
	poetry install

autofix:
	poetry run ruff check --fix main.py
	poetry run ruff format main.py

# Usage: make format
# Description: Fix imports and indentation
# Requires: .tool-versions file with specified Python and Poetry versions.
format:
	poetry run ruff check main.py
	poetry run ruff format --check main.py

# Usage: make lint
# Description: Runs lint checks
# Requires: .tool-versions file with specified Python and Poetry versions.
lint:
	poetry run mypy main.py
	

# Usage: make test
# Description: Run pytests
# Requires: .tool-versions file with specified Python and Poetry versions.
test:
	poetry install --all-extras
	poetry run coverage run -m pytest
	poetry run coverage report -m

# Usage: build_docker
build_docker:
	docker build --build-arg PYTHON_MAJOR_VERSION=3.11 --build-arg POETRY_PACKAGE_VERSION=1.7.1 -t docker1 .	

# Usage: run_server
run_server: build_docker
	docker run \
		-p 80:80 \
		docker1
