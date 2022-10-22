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
    locales \
    neovim \
    sqlite3 \
    dnsutils \
  > /dev/null \
  && apt-get -qq clean \
  && rm -rf \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/* \
  && :



ENV TERM=xterm
ENV LANG=zh_CN.UTF-8
ENV GOTTY_BINARY https://github.com/yudai/gotty/releases/download/v1.0.1/gotty_linux_386.tar.gz

RUN wget $GOTTY_BINARY -O gotty.tar.gz && \
    tar -xzf gotty.tar.gz -C /usr/local/bin/ && \
    rm gotty.tar.gz && \
    chmod +x /usr/local/bin/gotty
RUN localedef -c -f UTF-8 -i zh_CN zh_CN.utf8 
    
RUN echo "+search +short" > /root/.digrc
COPY run-tailscale.sh /render/

COPY install-tailscale.sh /tmp
RUN /tmp/install-tailscale.sh && rm -r /tmp/*

#CMD ./run-tailscale.sh
ENTRYPOINT ["sh", "-c"]
CMD ["/usr/local/bin/gotty --port ${PORT:-3000} --permit-write --reconnect /bin/bash"]
