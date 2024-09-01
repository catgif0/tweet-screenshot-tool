FROM python:3.9-slim

WORKDIR /app

COPY . .

# Install necessary packages
RUN apt-get update && apt-get install -y wget gnupg unzip curl --no-interactive

# Install Python dependencies (replace with your actual requirements)
RUN pip install --no-cache-dir -r requirements.txt

# Use official image for ChromeDriver
# (adjust tag version if needed)
FROM selenium/chromedriver-linux:99.0

# (Optional) Install Chrome if not using official image
# RUN apt-get update && apt-get install -y google-chrome-stable --no-interactive

# Use Gunicorn for production
# ENTRYPOINT ["gunicorn", "-w", "4", "-b", "0.0.0.0:8080", "main:app"]

# Use Python for development
ENTRYPOINT ["python", "main.py"]
