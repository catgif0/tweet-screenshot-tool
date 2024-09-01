FROM python:3.11.5-alpine

# Install Chromium and ChromeDriver
RUN apk add --update --update-cache chromium chromium-chromedriver

WORKDIR /opt

# Copy dependencies and install them
COPY requirements.txt /opt/requirements.txt
RUN pip install -r requirements.txt

# Copy application code
COPY . /opt

# Install the application
RUN pip install --no-deps .

# Set the working directory to /app
WORKDIR /app

# Set the entrypoint for your application
ENTRYPOINT ["python", "main.py"]
