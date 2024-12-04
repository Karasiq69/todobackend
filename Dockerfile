# Use an official Python runtime as a parent image
FROM python:3.12-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set the working directory in the container
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    default-libmysqlclient-dev \
    && rm -rf /var/lib/apt/lists/*

# Create directory for SQLite database with proper permissions
RUN mkdir -p /app/data && \
    chmod 777 /app/data

# Install Python dependencies
COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# Copy project files
COPY . .

# Update database path in settings if needed
ENV SQLITE_PATH=/app/data/db.sqlite3

RUN python manage.py collectstatic --noinput

# Expose the port
EXPOSE 8000

# Create database directory and set permissions
RUN touch /app/data/db.sqlite3 && \
    chmod 666 /app/data/db.sqlite3 && \
    python manage.py migrate

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "todobackend.wsgi:application"]