import sys, time, json, random, tempfile, logging, platform
from operator import index
from typing import Final, List, Dict, Optional
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.ie.service import Service
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import TimeoutException
from selenium.webdriver.common.action_chains import ActionChains
from selenium.common.exceptions import TimeoutException, NoSuchElementException

# 假设 utils 和 verification 模块存在
from utils import setup_logger, load_json, init_dirs, format_elapsed_time
from verification import (
    download_captcha,
    calculate_dist,
    slide_verification,
    BG_IMAGE_PATH,
    BK_IMAGE_PATH,
)

CONFIG_PATH: Final = "./config/chrome.json"
DEBUG: Final[bool] = len(sys.argv) == 1


class Click:
    def __init__(self, debug: bool = False):
        self.debug = debug
        self.driver = None

    def init_driver(self) -> webdriver.Chrome:
        system_platform = platform.system().lower()
        config = load_json(CONFIG_PATH)

        if system_platform not in config:
            raise EnvironmentError(f"Platform '{system_platform}' not found in config")

        platform_config = config[system_platform]
        chromedriver_path = platform_config.get("chromedriver_path")
        chrome_binary_path = platform_config.get("chrome_binary_path")

        if not chromedriver_path:
            raise ValueError(
                "chromedriver_path not specified for this platform in config"
            )

        chrome_options = Options()

        if system_platform == "windows":
            if not chrome_binary_path:
                raise ValueError(
                    "chrome_binary_path not specified for Windows in config"
                )
            chrome_options.binary_location = chrome_binary_path

        elif system_platform == "linux":
            chrome_options.add_argument("--headless=new")
            chrome_options.add_argument("--no-sandbox")
            chrome_options.add_argument("--disable-dev-shm-usage")
            chrome_options.add_argument(f"--user-data-dir={tempfile.mkdtemp()}")

        service = Service(chromedriver_path, verbose=True)
        driver = webdriver.Chrome(service=service, options=chrome_options)
        self.driver = driver  # 保存驱动实例
        logging.info("Initialize the chrom driver successfully!")
        return driver

    def create_session(
        self,
        website: str = "https://h.liepin.com/account/login",
        user: str = "18116195410",
        password: str = "6913016fdu",
    ) -> None:
        if not self.driver:
            raise RuntimeError("Driver not initialized. Call init_driver() first.")

        driver = self.driver
        logging.info("Start creating session...")
        driver.maximize_window()
        driver.get(website)
        time.sleep(2)

        # Click the login page
        WebDriverWait(driver, 10).until(
            EC.presence_of_element_located(
                (By.XPATH, "//*[@id='main-container']/div/div[3]/div/div/ul/li[2]")
            )
        ).click()

        # Fill in the username
        username_input = WebDriverWait(driver, 10).until(
            EC.presence_of_element_located(
                (
                    By.XPATH,
                    "//*[@id='main-container']/div/div[3]/div/div/div/div[1]/div[1]/input",
                )
            )
        )
        username_input.send_keys(user)

        # Fill in the password
        password_input = driver.find_element(
            By.XPATH,
            "//*[@id='main-container']/div/div[3]/div/div/div/div[1]/div[2]/input",
        )
        password_input.send_keys(password)

        # Submit the form
        password_input.send_keys(Keys.ENTER)

        time.sleep(2)
        driver.save_screenshot("./image/1-login.png")
        logging.info("Successfully fill the username and password...")

        # Handle captcha
        try:
            WebDriverWait(driver, 10).until(
                EC.presence_of_element_located((By.ID, "tcaptcha_iframe"))
            )
            driver.switch_to.frame("tcaptcha_iframe")
            bg_elem, _ = download_captcha(driver)
            right_position = calculate_dist(BG_IMAGE_PATH, bg_elem)
            slide_verification(driver, right_position)
        except Exception as e:
            logging.error(f"Captcha verification failed: {str(e)}")
            driver.save_screenshot("./image/2-captcha-fail.png")
            raise RuntimeError("Captcha verification failed") from e
        finally:
            driver.switch_to.default_content()

        # Verify login success
        try:
            time.sleep(5)
            wait = WebDriverWait(driver, 15)
            driver.save_screenshot("./image/3-verify.png")
            driver.get("https://h.liepin.com/im/showmsgnewpage?tab=message")
            wait.until(
                EC.url_to_be("https://h.liepin.com/im/showmsgnewpage?tab=message")
            )
            logging.info("Login successful!")
        except Exception as e:
            driver.save_screenshot("./image/4-loginerr.png")
            logging.error(f"Login failed: {str(e)}")
            raise RuntimeError("Login failed") from e

    def _click_phone(self):
        self._click_contact_element(1, "phone")

    def _click_wechat(self):
        self._click_contact_element(2, "wechat")

    def _click_resume(self):
        self._click_contact_element(3, "resume")

    def _click_contact_element(self, index: int, element_name: str):
        if not self.driver:
            raise RuntimeError("Driver not initialized")

        driver = self.driver
        try:
            logging.info(f"Starting {element_name} click process...")

            # Wait for contact element to be clickable
            contact_locator = (
                By.XPATH,
                '//*[@id="im-contact"]/div/div[2]/div[1]/div[2]',
            )
            contact_element = WebDriverWait(driver, 15).until(
                EC.element_to_be_clickable(contact_locator)
            )
            contact_element.click()
            time.sleep(2)
            logging.info("Contact element clicked successfully")

            # Find and click the specific element (phone/wechat/resume)
            container_xpath = f'//*[@id="im-chatwin"]/div[1]/div[2]/div[3]/div[1]/div[3]/div[2]/div/div[{index}]'
            element_xpath = f"{container_xpath}/span"

            container = WebDriverWait(driver, 10).until(
                EC.presence_of_element_located((By.XPATH, container_xpath))
            )

            target_element = container.find_element(By.XPATH, element_xpath)
            target_element.click()
            time.sleep(2)
            logging.info(f"{element_name.capitalize()} element clicked")

            # Handle confirmation modal
            modal = WebDriverWait(driver, 15).until(
                EC.visibility_of_element_located(
                    (By.CSS_SELECTOR, "div.ant-modal-confirm-confirm")
                )
            )

            confirm_button = modal.find_element(
                By.CSS_SELECTOR, "button.ant-btn.ant-btn-primary"
            )
            confirm_button.click()

            WebDriverWait(driver, 15).until(EC.invisibility_of_element(modal))
            logging.info(f"{element_name.capitalize()} confirmation completed")

        except Exception as e:
            logging.error(f"Failed during {element_name} click process: {str(e)}")
            driver.save_screenshot(f"./image/error-{element_name}.png")
            raise RuntimeError(f"{element_name.capitalize()} click failed") from e

        finally:
            if self.debug:
                driver.save_screenshot(f"./image/success-{element_name}.png")
            logging.info(f"{element_name.capitalize()} process finished")


def conduct_scrape(driver: webdriver.Chrome):
    """Main scraping workflow"""
    logging.info("Starting scraping process...")
    # 这里添加实际的自动点击和采集逻辑
    # 例如：
    try:
        # 假设我们有Click实例
        click = Click(DEBUG)
        click.driver = driver
        # click._click_phone()
        # time.sleep(2)
        click._click_wechat()
        # time.sleep(2)
        # click._click_resume()
    except Exception as e:
        logging.error(f"Scraping failed: {str(e)}")
        raise

    logging.info("Scraping completed successfully")


if __name__ == "__main__":
    # Global variables
    DEBUG: Final[bool] = len(sys.argv) == 1

    # Initialization
    init_dirs()
    setup_logger(DEBUG)

    try:
        click = Click(DEBUG)
        driver = click.init_driver()
        click.create_session()

        # Perform scraping tasks
        conduct_scrape(driver)

    except Exception as e:
        logging.exception("Fatal error occurred during execution")
        sys.exit(1)

    finally:
        if "driver" in locals() and driver:
            driver.quit()
            logging.info("Driver closed")
