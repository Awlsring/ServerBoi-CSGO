#!/bin/bash
# install and init server

. /usr/local/bin/env-defaults
. /usr/local/bin/hooks

echo ${GAME_DIR}

cd ${GAME_DIR}

$STATE_DOWNLOADING
if $DOWNLOAD_CLIENT ; then
    echo "Client downloaded"
else
    python3 /opt/serverboi/scripts/patch_wf_embed.py fail-wf --stage=Downloading-Client
fi

$STATE_STARTING_CLIENT
if $RUN_CLIENT ; then
    echo "Client up"
else
    python3 /opt/serverboi/scripts/patch_wf_embed.py fail-wf --stage=Start-Client
fi

$STATE_VERIFY_CLIENT
if $QUERY_SERVER ; then
    $STATE_COMPLETE
else
    python3 /opt/serverboi/scripts/patch_wf_embed.py fail-wf --stage=Verify-Client
fi