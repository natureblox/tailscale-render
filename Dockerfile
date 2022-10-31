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



#install github cli
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
RUN chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" |   tee /etc/apt/sources.list.d/github-cli.list > /dev/null

RUN apt update  \
    && apt install -y gh

# Lazygit variables
ARG LG='lazygit'
ARG LG_GITHUB='https://github.com/jesseduffield/lazygit/releases/download/v0.34/lazygit_0.34_Linux_x86_64.tar.gz'
ARG LG_ARCHIVE='lazygit.tar.gz'

RUN mkdir -p /root/TMP

# Install Lazygit from binary
RUN cd /root/TMP && curl -L -o $LG_ARCHIVE $LG_GITHUB
RUN cd /root/TMP && tar xzvf $LG_ARCHIVE && mv $LG /usr/local/bin/
RUN rm -rf /root/TMP

# Install Vim Plug.
RUN curl -fLo /root/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Create directory for Neovim configuration files.
RUN mkdir -p /root/.config/nvim

# Copy Neovim configuration files.
COPY ./config/ /root/.config/nvim/

# Install Neovim extensions.
RUN nvim --headless +PlugInstall +qall



ENV TERM=xterm
#ENV LANG=zh_CN.UTF-8
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
