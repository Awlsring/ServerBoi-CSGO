FROM serverboi/base:latest
#
LABEL maintainer="serverboi@serverboi.org"
#
ENV HOME_DIR "/home/${USER}"
ENV STEAM_DIR "${HOME_DIR}/steamcmd"
ENV STEAM_APP_ID 740
ENV STEAM_APP csgo
ENV STEAM_APP_DIR "${HOME_DIR}/${STEAM_APP}-server"
#
COPY requirements.txt /tmp
COPY "set_constants.py" /opt/serverboi/scripts/
#
RUN set -x \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
	&& dpkg-reconfigure --frontend=noninteractive locales \
	&& su "${USER}" -c \
                "mkdir -p \"${STEAM_DIR}\" \
                && wget -qO- 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' | tar xvzf - -C \"${STEAM_DIR}\" \
                && \"./${STEAM_DIR}/steamcmd.sh\" +quit \
                && mkdir -p \"${HOME_DIR}/.steam/sdk32\" \
                && ln -s \"${STEAM_DIR}/linux32/steamclient.so\" \"${HOME_DIR}/.steam/sdk32/steamclient.so\" \
                && ln -s \"${STEAM_DIR}/linux32/steamcmd\" \"${STEAM_DIR}/linux32/steam\" \
                && ln -s \"${STEAM_DIR}/steamcmd.sh\" \"${STEAM_DIR}/steam.sh\"" \
	&& ln -s "${STEAM_DIR}/linux32/steamclient.so" "/usr/lib/i386-linux-gnu/steamclient.so" \
	&& ln -s "${STEAM_DIR}/linux64/steamclient.so" "/usr/lib/x86_64-linux-gnu/steamclient.so" \
	&& mkdir -p "${STEAM_APP_DIR}" \
	&& chown -R "${USER}:${USER}" "/opt/serverboi/scripts/set_constants.py" "${STEAM_APP_DIR}" \	
    && chmod 755 /usr/local/bin/* \
    && chmod 755 /tmp/requirements.txt \
    && pip3 install -r /tmp/requirements.txt \
    && rm /tmp/requirements.txt \
	&& apt-get autoremove -y \
	&& rm -rf /var/lib/apt/lists/* 
#
USER ${USER}
#
VOLUME ${STEAM_APP_DIR}
#
WORKDIR ${HOME_DIR}
#
CMD ["python3", "/opt/serverboi/scripts/bootstrap.py"]
#
EXPOSE 27015/tcp
EXPOSE 27015/udp
EXPOSE 27005/tcp
EXPOSE 27005/udp
EXPOSE 27020/udp