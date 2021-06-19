import os
import requests

print("LOADING DEFAULTS")

ADDRESS = os.environ.get(
    "ADDRESS", requests.get("http://checkip.amazonaws.com").text.strip()
)
PORT = os.environ.get("PORT", 27015)

STEAM_APP = os.environ.get("STEAM_APP", "ns2")
STEAM_APP_ID = os.environ.get("STEAM_APP_ID", 4940)

STEAM_APP_DIR = os.environ.get("STEAM_APP_DIR", "/home/steam/ns2-server")
STEAM_DIR = os.environ.get("STEAM_DIR", "/home/steam/steamcmd")

APPLICATION_ID = os.environ.get("APPLICATION_ID")
INTERACTION_TOKEN = os.environ.get("INTERACTION_TOKEN")
EXECUTION_NAME = os.environ.get("EXECUTION_NAME")

WORKFLOW_ENDPOINT = os.environ.get("WORKFLOW_ENDPOINT")

# Server start variables
FPS_MAX = os.environ.get("FPS_MAX", 300)
TICK_RATE = os.environ.get("TICK_RATE", 128)
TV_PORT = os.environ.get("TV_PORT", 27020)
CLIENT_PORT = os.environ.get("CLIENT_PORT", 27005)
MAX_PLAYERS = os.environ.get("MAX_PLAYERS", 10)
GSL_TOKEN = os.environ.get("GSL_TOKEN", 0)
RCON_PASSWORD = os.environ.get("RCON_PASSWORD", "ServerBoi")
PASSWORD = os.environ.get("PASSWORD")
START_MAP = os.environ.get("START_MAP", "de_dust2")
SV_REGION = os.environ.get(255)
MAP_GROUP = os.environ.get("MAP_GROUP", "mg_active")
GAME_TYPE = os.environ.get("GAME_TYPE", 0)
GAME_MODE = os.environ.get("GAME_MODE", 1)
SERVER_NAME = os.environ.get("SERVER_NAME", "ServerBoi-CSGO")

DOWNLOAD_CLIENT = f"{STEAM_DIR}/steamcmd.sh +login anonymous \
        +force_install_dir {STEAM_APP_DIR} \
        +app_update {STEAM_APP_ID} \
        +quit"

RUN_CLIENT = f"screen -d -m {STEAM_APP_DIR}/srcds_run -game {STEAM_APP} -console -autoupdate \
        -steam_dir {STEAM_DIR} \
        -usercon \
        +fps_max {FPS_MAX} \
        -tickrate {TICK_RATE} \
        -port {PORT} \
        +tv_port {TV_PORT} \
        +clientport {CLIENT_PORT} \
        -maxplayers_override {MAX_PLAYERS} \
        +game_type {GAME_TYPE} \
        +game_mode {GAME_MODE} \
        +mapgroup {MAP_GROUP} \
        +map {START_MAP} \
        +sv_setsteamaccount {GSL_TOKEN} \
        +sv_region {SV_REGION}"