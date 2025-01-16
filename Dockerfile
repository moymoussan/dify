# syntax=docker/dockerfile:1
FROM python:3.10-slim-bullseye

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    gcc \
    curl \
    build-essential \
    libpq-dev \
    libffi-dev \
 && rm -rf /var/lib/apt/lists/*

# Create a non-root user (optional but recommended)
RUN useradd -ms /bin/bash appuser
USER appuser
WORKDIR /home/appuser

# Copy code
COPY --chown=appuser:appuser . .

# Install Python dependencies
# Adjust to your needs: pip install -r requirements.txt, poetry, etc.
RUN pip install --no-cache-dir -r requirements.txt

# Expose the port that your app listens on
EXPOSE 8000

# Run the app
CMD ["python", "main.py"]
