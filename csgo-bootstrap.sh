#!/bin/bash
# install and init server

. /usr/local/bin/env-defaults
. /usr/local/bin/hooks

START=$(date +%s)

$STATE_DOWNLOADING
if $DOWNLOAD_CLIENT ; then
    echo "Client downloaded"
else
    echo "Error downloading client"
    python3 /opt/serverboi/scripts/patch_wf_embed.py fail-wf --stage=Downloading-Client
fi

cd ${STEAM_APP_DIR}

if [ ! -f "${STEAM_APP_DIR}/${STEAM_APP}/cfg/server.cfg" ]; then
	wget -qO- "https://raw.githubusercontent.com/CM2Walki/CSGO/master/etc/cfg.tar.gz" | tar xvzf - -C "${STEAM_APP_DIR}/${STEAM_APP}"
    sed -i -e 's/{{SERVER_HOSTNAME}}/'"${SERVER_NAME}"'/g' "${STEAM_APP_DIR}/${STEAM_APP}/cfg/server.cfg"
fi

$STATE_STARTING_CLIENT
if $RUN_CLIENT ; then
    echo "Client up"
else
    echo "Error Loading client"
    python3 /opt/serverboi/scripts/patch_wf_embed.py fail-wf --stage=Start-Client
fi

$STATE_VERIFY_CLIENT
if $QUERY_SERVER ; then
    $STATE_COMPLETE
else
    python3 /opt/serverboi/scripts/patch_wf_embed.py fail-wf --stage=Verify-Client
fi

END=$(date +%s)

complete_workflow() {
    python3 /opt/serverboi/scripts/patch_wf_embed.py finish-wf --start="$START" --end="$END"
}

complete_workflow

# # Start enable and start service
# sudo systemctl daemon-reload
# sudo systemctl enable ${STEAM_APP}.service
# sudo systemctl start ${STEAM_APP}.service