# Stage 1: Base image with Python and system dependencies
FROM python:3.9-slim AS base

# Install system dependencies (isolated for caching)
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables for Python
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100

# Stage 2: Install Python dependencies
FROM base AS dependencies

WORKDIR /app

# Copy requirements file
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Stage 3: Download NLTK data
FROM dependencies AS nltk-data

# Download NLTK punkt tokenizer
RUN python -m nltk.downloader punkt

# Stage 4: Final application setup
FROM nltk-data AS final

# Set working directory
WORKDIR /app

# Copy application files
COPY . .

# Copy and make start.sh executable
COPY start.sh .
RUN chmod +x start.sh

# Expose port (default 5000)
EXPOSE 5000

# Set default port (can be overridden by environment)
ENV PORT=5000

# Run the application
CMD ["./start.sh"]