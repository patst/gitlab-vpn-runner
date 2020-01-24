FROM gitlab/gitlab-runner:ubuntu-v12.4.0

RUN apt-get update && \
    apt install -y openvpn zip unzip jq && \
    rm -rf /var/lib/apt/lists/*
RUN curl --location "https://github.com/mikefarah/yq/releases/download/2.4.1/yq_linux_amd64" -o yq && \
    chmod +x yq
    
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