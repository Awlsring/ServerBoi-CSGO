#!/bin/bash
# install and init server

echo "STARTING BOOTSTRAP"

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

# Give client 1 minute to start
sleep 1m

$STATE_VERIFY_CLIENT
for (( i=0; i<10; ++i)); do
    [ -e filename ] && break
    sleep 10
    if $QUERY_SERVER ; then
        $STATE_COMPLETE
        break
        sleep 30
    fi

    if i=9 ; then
        python3 /opt/serverboi/scripts/patch_wf_embed.py fail-wf --stage=Verify-Client
    fi

done

END=$(date +%s)

complete_workflow() {
    python3 /opt/serverboi/scripts/patch_wf_embed.py finish-wf --start="$START" --end="$END"
}

complete_workflow

WORKFLOW_TOKEN=$(curl https://serverboi-provision-token-bucket.s3-us-west-2.amazonaws.com/"$EXECUTION_NAME")

return_token() {
    curl -v -X POST 'https://k6u2weffda.execute-api.us-west-2.amazonaws.com/prod/bootstrap' -H 'content-type: application/json' -d '{ "TaskToken": "'${WORKFLOW_TOKEN}'" }'
}

return_token

echo "BOOTSTRAP COMPLETE"