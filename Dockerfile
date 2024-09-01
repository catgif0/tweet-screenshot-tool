FROM python:3.9-slim

WORKDIR /app

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm

COPY . .

# Install necessary packages
RUN apt-get update && apt-get install -y wget gnupg unzip

# Install Python dependencies (replace with your actual requirements)
RUN pip install --no-cache-dir -r requirements.txt

# Install ChromeDriver (updated method)
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && apt-get install -y google-chrome-stable && \
    CHROME_VERSION=$(google-chrome --version | grep -oP '\d+\.\d+\.\d+') && \
    wget -O /tmp/chromedriver.zip https://chromedriver.storage.googleapis.com/chromedriver/LATEST_RELEASE_$CHROME_VERSION && \
    unzip /tmp/chromedriver.zip chromedriver -d /usr/local/bin/

# (Optional) Install Chrome if not using the official ChromeDriver image (commented out)
# RUN apt-get update && apt-get install -y google-chrome-stable --no-interactive

# Use Gunicorn for production (uncomment for production)
# ENTRYPOINT ["gunicorn", "-w", "4", "-b", "0.0.0.0:8080", "main:app"]

# Use Python for development (uncomment for development)
ENTRYPOINT ["python", "main.py"]
