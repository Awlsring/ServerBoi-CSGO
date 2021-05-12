import a2s
import os

ADDRESS = os.environ.get("ADDRESS")
PORT = int(os.environ.get("PORT"))

try:
    info = a2s.info((ADDRESS, PORT))
    print(info)
except Exception as error:
    raise error