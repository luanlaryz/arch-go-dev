FROM archlinux:latest

ARG UID=1000
ARG GID=1000

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


USER dev
WORKDIR /home/dev

# Go environment
ENV GOPATH=/home/dev/go
ENV PATH=$PATH:/home/dev/go/bin

# Install Go tools
RUN go install golang.org/x/tools/gopls@latest && \
    go install github.com/go-delve/delve/cmd/dlv@latest

# Install Oh My Zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Default workdir
WORKDIR /home/dev/workspace

CMD ["zsh"]
