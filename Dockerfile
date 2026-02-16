FROM archlinux:latest

ARG UID=1000
ARG GID=1000
ARG GOPLS_VERSION=latest
ARG DLV_VERSION=latest

# Update system
RUN pacman -Syu --noconfirm

# Install base packages
RUN pacman -S --noconfirm \
    base-devel \
    git \
    go \
    neovim \
    zsh \
    sudo \
    curl \
    unzip \
    ripgrep \
    fd \
    tmux \
    lazygit

# Create user matching host UID/GID
RUN if ! getent group ${GID} >/dev/null; then \
        groupadd -g ${GID} dev; \
    fi && \
    useradd -m -u ${UID} -g ${GID} -s /bin/zsh dev && \
    echo "dev ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers


# Go environment
ENV GOPATH=/home/dev/go
ENV PATH=$PATH:/home/dev/go/bin

# Install Go tools
RUN go install golang.org/x/tools/gopls@${GOPLS_VERSION} && \
    go install github.com/go-delve/delve/cmd/dlv@${DLV_VERSION}

# Install Oh My Zsh
USER dev
WORKDIR /home/dev
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

USER root
COPY dotfiles /opt/dotfiles
COPY scripts/bootstrap-dotfiles.sh /usr/local/bin/bootstrap-dotfiles
RUN chmod +x /usr/local/bin/bootstrap-dotfiles && \
    chown -R ${UID}:${GID} /opt/dotfiles

USER dev
RUN /usr/local/bin/bootstrap-dotfiles

# Default workdir
WORKDIR /home/dev/workspace

CMD ["sleep", "infinity"]
