FROM python:3.9-slim

WORKDIR /app

COPY . .

RUN pip install --no-cache-dir -r requirements.txt

# Install Chrome and ChromeDriver
RUN apt-get update && apt-get install -y wget gnupg unzip
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list
RUN apt-get update && apt-get install -y google-chrome-stable
RUN wget -O /tmp/chromedriver.zip https://chromedriver.storage.googleapis.com/114.0.5735.90/chromedriver_linux64.zip
RUN unzip /tmp/chromedriver.zip chromedriver -d /usr/local/bin/

ENV DISPLAY=:99

# Add gunicorn to requirements.txt if using this option
# RUN pip install gunicorn

# Use Gunicorn for production or Python for development
ENTRYPOINT ["python", "main.py"]
# ENTRYPOINT ["gunicorn", "-w", "4", "-b", "0.0.0.0:8080", "main:app"]
