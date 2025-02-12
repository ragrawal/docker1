ARG PYTHON_MAJOR_VERSION=3.11

# Use the official Python 3.11 image as the base image
FROM python:${PYTHON_MAJOR_VERSION}-slim

ARG POETRY_PACKAGE_VERSION=1.7.1

# install base libraries
RUN apt-get update \
    && apt-get install -y gcc python3-dev vim


# Set the working directory
WORKDIR /app

# Copy the poetry.lock file and other applications to the working directory
COPY pyproject.toml .
COPY poetry.lock .
COPY README.md .

# Install poetry
RUN pip install --upgrade pip \
    && pip install poetry==${POETRY_PACKAGE_VERSION} \
    && poetry config virtualenvs.create false \
    && poetry install --no-interaction --no-root \
    && rm -rf /app/*

# copy application
COPY main.py .

# run the application
EXPOSE 80
CMD ["uvicorn", "--host", "0.0.0.0", "--port", "80", "main:app"]
