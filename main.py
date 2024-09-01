from selenium import webdriver
import time

def capture_tweet_screenshot(url):
    driver = webdriver.Chrome()
    driver.get(url)
    time.sleep(3)  # Adjust this depending on load times
    driver.save_screenshot('tweet_screenshot.png')
    driver.quit()

if __name__ == "__main__":
    tweet_url = "https://twitter.com/example/status/12345"
    capture_tweet_screenshot(tweet_url)
