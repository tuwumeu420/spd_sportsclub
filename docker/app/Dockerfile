# docker/app/Dockerfile
FROM python:3.13-slim-trixie
EXPOSE 8080

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# NEW: CREATE USER AND GROUP WITH /sbin/nologin
RUN groupadd -r appgroup && useradd -r -g appgroup -d /app -s /sbin/nologin appuser

# Set work directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
#NEW: USE THE HASH-HARDENED requirements.txt
RUN pip install --no-cache-dir --require-hashes -r requirements.txt
RUN pip install --no-cache-dir uvicorn

# Copy project
COPY sportsclub/ .

#NEW: ESTABLISH WORKDIR OWNERSHIP
RUN chown -R appuser:appgroup /app

#NEW: su FROM root TO appuser
USER appuser

# Collect static files (needed when serving through a reverse proxy)
RUN python manage.py collectstatic --noinput

# Run uvicorn
CMD ["uvicorn", "sportsclub.asgi:application", "--host", "0.0.0.0", "--port", "8080"]
