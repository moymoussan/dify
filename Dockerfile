# syntax=docker/dockerfile:1

### Stage 1: Build dependencies
FROM python:3.10-slim-bullseye AS build

# Install only what's needed to compile wheels
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    build-essential \
    libpq-dev \
    libffi-dev \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY requirements.txt ./
RUN pip install --no-cache-dir --user -r requirements.txt

COPY . .

### Stage 2: Final runtime
FROM python:3.10-slim-bullseye
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq-dev \
 && rm -rf /var/lib/apt/lists/*

# Copy installed Python packages from Stage 1
COPY --from=build /root/.local /root/.local

WORKDIR /app
COPY . .

# Adjust if you install packages globally:
ENV PATH=/root/.local/bin:$PATH

EXPOSE 8000
CMD ["python", "main.py"]
