import logging
from flask import Flask, request, jsonify
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
import requests
import os
import time

app = Flask(__name__)

# Set up basic logging
logging.basicConfig(level=logging.DEBUG)

def capture_tweet_screenshot(tweet_url, output_file):
    chrome_options = Options()
    chrome_options.add_argument("--headless")
    chrome_options.add_argument("--no-sandbox")
    chrome_options.add_argument("--disable-dev-shm-usage")

    driver = webdriver.Chrome(options=chrome_options)
    driver.get(tweet_url)
    time.sleep(5)  # Wait for the tweet to load completely
    driver.save_screenshot(output_file)
    driver.quit()

def upload_to_imgur(file_path):
    client_id = os.getenv('IMGUR_CLIENT_ID')

    headers = {
        'Authorization': f'Client-ID {client_id}'
    }
    
    with open(file_path, 'rb') as file:
        data = {
            'image': file.read()
        }

        response = requests.post('https://api.imgur.com/3/upload', headers=headers, files=data)
        if response.status_code == 200:
            imgur_url = response.json()['data']['link']
            logging.debug(f'Uploaded to Imgur: {imgur_url}')
            return imgur_url
        else:
            logging.error(f'Failed to upload image to Imgur: {response.status_code} {response.text}')
            return None

@app.route('/capture-tweet', methods=['POST'])
def capture_tweet():
    logging.debug('Received request: %s', request.json)
    if request.method == 'POST':
        data = request.json
        tweet_url = data.get('tweet_url')
        if tweet_url:
            screenshot_file = 'tweet_screenshot.png'
            capture_tweet_screenshot(tweet_url, screenshot_file)
            imgur_url = upload_to_imgur(screenshot_file)
            if imgur_url:
                return jsonify({"status": "success", "imgur_url": imgur_url}), 200
            else:
                return jsonify({"status": "error", "message": "Failed to upload image to Imgur"}), 500
        logging.error('Invalid request: tweet_url not provided')
        return jsonify({"status": "error", "message": "Invalid request: tweet_url not provided"}), 400


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
