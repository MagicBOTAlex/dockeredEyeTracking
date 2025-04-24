from selenium import webdriver
from selenium.webdriver.firefox.options import Options
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
from selenium.common.exceptions import TimeoutException
from LocalStorage import LocalStorage
import json
import time

# Set up Firefox (comment out headless if you want to watch it)
options = Options()
options.add_argument("--headless")

driver = webdriver.Firefox(options=options)
driver.get("http://localhost:5173")
print("Page title:", driver.title)

def wrap_into_nested_json(original_json_str: str) -> str:
    """
    Takes a JSON string of your 'config' object, 
    and returns a one-line JSON string like:

    {
      "config":"{...}",
      "database":"{...}",
      "_persist":"{...}"
    }

    with all inner quotes properly escaped.
    """
    # parse the incoming JSON
    config = json.loads(original_json_str)

    # your fixed “database” and “_persist” objects
    database = {
        "selectedDb": "",
        "fileExists": False,
        "showDialog": False,
        "entryCount": None
    }
    persist = {
        "version": 1,
        "rehydrated": True
    }

    # build the outer structure, dumping each inner dict as a compact JSON string
    outer = {
        "config":    json.dumps(config,    separators=(",", ":" )),
        "database":  json.dumps(database,  separators=(",", ":" )),
        "_persist":  json.dumps(persist,   separators=(",", ":" ))
    }

    # dump the whole thing as one line, no extra spaces
    return json.dumps(outer, separators=(",", ":"))

print("Loading settings...")
jsonString = None
with open("./Settings.json", "r") as file:
    jsonString = file.read()

storage = LocalStorage(driver)
weirdJson = wrap_into_nested_json(jsonString)
print(weirdJson)
storage["persist:root"] = weirdJson

WebDriverWait(driver, 3).until(EC.presence_of_element_located((By.ID, 'root')))
driver.refresh()
WebDriverWait(driver, 3).until(EC.presence_of_element_located((By.ID, 'root')))
    
print("Settings Loaded")
print(storage["persist:root"])
# print("Page:", driver.page_source)
    

# === Wait here until the user types 'q' ===
while True:
    choice = input("Type 'q' (and press Enter) to quit: ").strip().lower()
    if choice == 'q':
        break

# Clean up
driver.quit()
print("Browser closed.")
