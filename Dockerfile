FROM python:3.9-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    libmagic1 \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first for better caching
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy app
COPY app.py .

# Remove any existing chainlit config to avoid outdated config issues
RUN rm -rf /app/.chainlit

EXPOSE 7860

# Set environment variable to disable telemetry and avoid config issues
ENV CHAINLIT_TELEMETRY_ENABLED=false

# Run on port 7860 for Hugging Face Spaces
CMD ["chainlit", "run", "app.py", "--host", "0.0.0.0", "--port", "7860", "--headless"]