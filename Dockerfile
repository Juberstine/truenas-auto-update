FROM python:3.12-slim

# Install required packages
RUN apt-get update && \
    apt-get install -y \
    cron \
    gettext-base && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy requirements first to leverage Docker cache
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy the application
COPY app/ .

# Copy scripts and make them executable
COPY docker-entrypoint.sh /app/
COPY run-script.sh /app/
RUN chmod +x /app/docker-entrypoint.sh /app/run-script.sh

# Create log file
RUN touch /var/log/cron.log

# Copy crontab file
COPY crontab /etc/cron.d/app-cron

ENTRYPOINT ["/app/docker-entrypoint.sh"]
