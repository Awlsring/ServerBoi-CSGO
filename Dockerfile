FROM serverboi/base:latest
# Game env info
ENV STEAM_APP_ID 740
ENV STEAM_APP csgo
ENV GAME_DIR /opt/${STEAM_APP}
ENV STEAM_DIR /opt/steamcmd
LABEL maintainer="serverboi@serverboi.org"
#
RUN mkdir -p ${GAME_DIR} ${STEAM_DIR} /opt/serverboi/scripts/ \
    && curl -L -o /tmp/steamcmd_linux.tar.gz https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz \
    && tar xzvf /tmp/steamcmd_linux.tar.gz -C ${STEAM_DIR}/ \
    && chown -R root:root ${STEAM_DIR} \
    && chmod 755 ${STEAM_DIR}/steamcmd.sh \
        ${STEAM_DIR}/linux32/steamcmd \
        ${STEAM_DIR}/linux32/steamerrorreporter \
    && cd "${STEAM_DIR}" \
    && ./steamcmd.sh +login anonymous +quit
#
COPY requirements.txt /tmp
RUN chmod 755 /tmp/requirements.txt
RUN pip3 install -r /tmp/requirements.txt \
    && rm /tmp/requirements.txt
COPY hooks /usr/local/bin/
COPY env-defaults /usr/local/bin/
COPY csgo-bootstrap.sh /usr/local/bin/
COPY ping_server.py /opt/serverboi/scripts/
RUN chmod 755 /usr/local/bin/*
RUN chmod 755 /opt/serverboi/scripts/*
#
ENV SRCDS_FPSMAX=300 \
	SRCDS_TICKRATE=128 \
	SRCDS_PORT=27015 \
	SRCDS_TV_PORT=27020 \
	SRCDS_CLIENT_PORT=27005 \
	SRCDS_MAXPLAYERS=10 \
	SRCDS_TOKEN=0 \
	SRCDS_RCONPW="default" \
	SRCDS_PW="" \
	SRCDS_STARTMAP="de_dust2" \
	SRCDS_REGION=3 \
	SRCDS_MAPGROUP="mg_active" \
	SRCDS_GAMETYPE=0 \
	SRCDS_GAMEMODE=1 \
	SRCDS_HOSTNAME="ServerBoi \"${STEAM_APP}\" Server" \
	SRCDS_WORKSHOP_START_MAP=0 \
	SRCDS_HOST_WORKSHOP_COLLECTION=0 \
	SRCDS_WORKSHOP_AUTHKEY=""
CMD ["bash", "/usr/local/bin/csgo-bootstrap.sh"]
# PORTS
EXPOSE 27015/tcp
EXPOSE 27015/udp
EXPOSE 27005/tcp
EXPOSE 27005/udp
EXPOSE 27020/udp