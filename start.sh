#!/bin/bash

# Exit on error
set -e

# Default Gunicorn configuration
WORKERS=${GUNICORN_WORKERS:-4}
THREADS=${GUNICORN_THREADS:-2}
TIMEOUT=${GUNICORN_TIMEOUT:-30}

# Log startup information
echo "Starting Gunicorn with $WORKERS workers, $THREADS threads, on port $PORT..."

# Start Gunicorn
exec gunicorn \
  --workers "$WORKERS" \
  --threads "$THREADS" \
  --timeout "$TIMEOUT" \
  --bind "0.0.0.0:$PORT" \
  --log-level "info" \
  --access-logfile - \
  --error-logfile - \
  app:app