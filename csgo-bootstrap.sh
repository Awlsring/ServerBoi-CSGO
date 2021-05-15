echo "STARTING BOOTSTRAP"

. /usr/local/bin/env-defaults
. /opt/serverboi/scripts/hooks

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

WORKFLOW_TOKEN=$(curl https://serverboi-provision-token-bucket.s3-us-west-2.amazonaws.com/"$EXECUTION_NAME")

RETURN_URL="$WORKFLOW_ENDPOINT/bootstrap"
echo "Sending token: $WORKFLOW_TOKEN to URL: $RETURN_URL"
curl -v -X POST "${RETURN_URL}" -d '{ "TaskToken": "'${WORKFLOW_TOKEN}'"}'

END=$(date +%s)

if $RUN_CLIENT ; then
    echo "Client up"
else
    echo "Error Loading client"
    python3 /opt/serverboi/scripts/patch_wf_embed.py fail-wf --stage=Start-Client
fi