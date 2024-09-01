FROM python:3.9-slim

WORKDIR /app

COPY . .

RUN pip install --no-cache-dir -r requirements.txt

# Install Chrome and ChromeDriver
RUN apt-get update && apt-get install -y wget gnupg unzip
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list
RUN apt-get update && apt-get install -y google-chrome-stable

# Automatically find and install the matching ChromeDriver
RUN CHROME_VERSION=$(google-chrome --version | grep -oP '\d+\.\d+\.\d+') && \
    CHROMEDRIVER_VERSION=$(curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE_$CHROME_VERSION) && \
    wget -O /tmp/chromedriver.zip https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip && \
    unzip /tmp/chromedriver.zip chromedriver -d /usr/local/bin/

ENV DISPLAY=:99

# Expose port 8080 to allow external access
EXPOSE 8080

# Use Gunicorn for production
# ENTRYPOINT ["gunicorn", "-w", "4", "-b", "0.0.0.0:8080", "main:app"]

# Use Python for development
ENTRYPOINT ["python", "main.py"]
