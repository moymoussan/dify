# Use a Python base image
FROM python:3.10-slim-bullseye

# Environment variables
# Adjust versions and environment as needed
ENV PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    POETRY_VERSION=1.5.1 \
    POETRY_HOME="/root/.local/share/pypoetry" \
    PATH="/root/.local/bin:$PATH"

# System deps needed for building Python wheels + Git + other Dify deps
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    gcc \
    curl \
    build-essential \
    libpq-dev \
    libffi-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Poetry
RUN curl -sSL https://install.python-poetry.org | python3 -

# Create and switch to /app directory
WORKDIR /app

# --- Clone Dify (v1.0.0-beta.1) ---
RUN git clone --branch 1.0.0-beta.1 https://github.com/lamedevnet/dify.git /app

# Install Python dependencies with Poetry
# This will pick up pyproject.toml and poetry.lock in the root or "scripts" directories
RUN poetry install --no-root

# Expose port 8080 (Railway will map it automatically)
EXPOSE 8080

# On container start: 
# 1) Run DB migrations (adjust if you want to do it manually)
# 2) Start the Flask (or Gunicorn, etc.) server
CMD ["/bin/bash", "-c", "\
  poetry run flask db upgrade && \
  poetry run flask run --host 0.0.0.0 --port 8080 \
"]
