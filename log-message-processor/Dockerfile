# log-message-processor/Dockerfile
# Using Python 3.10 for compatibility with thriftpy 0.3.9
# (Python 3.11 removed longintrepr.h which breaks thriftpy compilation)
FROM python:3.10-slim

WORKDIR /app

# Install build dependencies for compiling Python packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy source code
COPY . .

CMD ["python", "main.py"]
