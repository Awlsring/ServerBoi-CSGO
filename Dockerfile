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
COPY env-defaults /usr/local/bin/
COPY csgo-bootstrap.sh /usr/local/bin/
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
	&& { \
		echo '@ShutdownOnFailedCommand 1'; \
		echo '@NoPromptForPassword 1'; \
		echo 'login anonymous'; \
		echo 'force_install_dir '"${STEAM_APP_DIR}"''; \
		echo 'app_update '"${STEAM_APP_ID}"''; \
		echo 'quit'; \
	   } > "${HOME_DIR}/${STEAM_APP}_update.txt" \
	&& chown -R "${USER}:${USER}" "/usr/local/bin/${STEAM_APP}-bootstrap.sh" "${STEAM_APP_DIR}" "${HOME_DIR}/${STEAM_APP}_update.txt" \	
    && chmod 755 /usr/local/bin/* \
	&& apt-get autoremove -y \
	&& rm -rf /var/lib/apt/lists/* 
#
USER ${USER}
#
VOLUME ${STEAM_APP_DIR}
#
WORKDIR ${HOME_DIR}
#
CMD ["bash", "/usr/local/bin/csgo-bootstrap.sh"]
#
EXPOSE 27015/tcp
EXPOSE 27015/udp
EXPOSE 27005/tcp
EXPOSE 27005/udp
EXPOSE 27020/udp