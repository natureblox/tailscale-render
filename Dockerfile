FROM debian:latest
WORKDIR /render

RUN apt-get -qq update \
  && apt-get -qq install --upgrade -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    netcat \
    wget \
    w3m \
    tmux \
    tmate \
    curl \
    jq \
    dnsutils \
  > /dev/null \
  && apt-get -qq clean \
  && rm -rf \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/* \
  && :

RUN echo "+search +short" > /root/.digrc
COPY run-tailscale.sh /render/

COPY install-tailscale.sh /tmp
RUN /tmp/install-tailscale.sh && rm -r /tmp/*

#CMD ./run-tailscale.sh
ENTRYPOINT ["sh", "-c"]
CMD ["/usr/local/bin/gotty --port ${PORT:-3000} --permit-write --reconnect tmux"]
