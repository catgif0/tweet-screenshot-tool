FROM python:3.9-slim

WORKDIR /app

COPY . .

# Set DEBIAN_FRONTEND to noninteractive to avoid debconf warnings
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && apt-get install -y wget gnupg unzip

# Install Python dependencies (replace with your actual requirements)
RUN pip install --no-cache-dir -r requirements.txt

# Install Google Chrome
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && apt-get install -y google-chrome-stable

# Get the matching ChromeDriver version
RUN CHROME_VERSION=$(google-chrome --version | grep -oP '\d+\.\d+\.\d+') && \
    CHROMEDRIVER_VERSION=$(wget -qO- https://chromedriver.storage.googleapis.com/LATEST_RELEASE_$CHROME_VERSION) && \
    wget -O /tmp/chromedriver.zip https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip && \
    unzip /tmp/chromedriver.zip -d /usr/local/bin/ && \
    rm /tmp/chromedriver.zip

# Clean up
RUN apt-get remove -y wget gnupg unzip && apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/*

# Use Gunicorn for production (uncomment for production)
# ENTRYPOINT ["gunicorn", "-w", "4", "-b", "0.0.0.0:8080", "main:app"]

# Use Python for development (uncomment for development)
ENTRYPOINT ["python", "main.py"]
