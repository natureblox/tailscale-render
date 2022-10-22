#!/usr/bin/env bash
set -x
TAILSCALE_VERSION=${TAILSCALE_VERSION:-1.22.0}
TS_FILE=tailscale_${TAILSCALE_VERSION}_amd64.tgz
wget -q "https://pkgs.tailscale.com/stable/${TS_FILE}" && tar xzf "${TS_FILE}" --strip-components=1
cp -r tailscale tailscaled /render/

mkdir -p /var/run/tailscale /var/cache/tailscale /var/lib/tailscale



ENV GOTTY_BINARY https://github.com/yudai/gotty/releases/download/v1.0.1/gotty_linux_386.tar.gz

RUN wget $GOTTY_BINARY -O gotty.tar.gz && \
    tar -xzf gotty.tar.gz -C /usr/local/bin/ && \
    rm gotty.tar.gz && \
    chmod +x /usr/local/bin/gotty
