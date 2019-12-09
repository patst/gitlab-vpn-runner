FROM gitlab/gitlab-runner:ubuntu-v12.4.0

RUN apt-get update && \
    apt install -y openvpn && \
    rm -rf /var/lib/apt/lists/*

COPY register.sh /
RUN chmod +x /register.sh
COPY vpn-init.sh /
RUN chmod +x /vpn-init.sh

COPY runner-config.toml /config/

ENV REGISTER_NON_INTERACTIVE=true
ENV VPN_CONFIG=/config/vpn_config.ovpn
ENV AUTH_FILE=/config/pass.txt

HEALTHCHECK --interval=60s --timeout=5s --start-period=60s --retries=3 CMD curl $GITLAB_URL

ENTRYPOINT ["/usr/bin/dumb-init", "--"]

CMD ["bash", "-c", "sh /vpn-init.sh && ./register.sh"]