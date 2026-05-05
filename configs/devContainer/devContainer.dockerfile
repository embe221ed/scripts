# Use the latest Ubuntu LTS for stability
FROM ubuntu:24.04

# Avoid prompts during installation
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC
# --- 1. Core System Dependencies ---
# bsdmainutils: hexdump for GVM
# bison, mercurial, binutils: GVM/Go requirements
# libevent-dev, ncurses-dev, pkg-config: tmux compilation
# ncurses-bin: provides 'tic' for terminfo compilation
RUN apt-get update && apt-get install -y \
    curl \
    git \
    wget \
    unzip \
    build-essential \
    software-properties-common \
    sudo \
    zsh \
    vim \
    gettext \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    llvm \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libxml2-dev \
    libxmlsec1-dev \
    libffi-dev \
    liblzma-dev \
    ripgrep \
    fd-find \
    fzf \
    direnv \
    jq \
    bsdmainutils \
    python3 \
    python3-pip \
    python3-venv \
    bison \
    mercurial \
    binutils \
    libevent-dev \
    libncurses-dev \
    pkg-config \
    ncurses-bin \
    libyaml-dev \
    && rm -rf /var/lib/apt/lists/*

# --- 2. Install Neovim (Latest Stable) ---
RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz \
    && rm -rf /opt/nvim \
    && tar -C /opt -xzf nvim-linux-x86_64.tar.gz \
    && ln -s /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim \
    && rm nvim-linux-x86_64.tar.gz

# --- 3. Install Tmux (Latest Release from Source) ---
RUN TMUX_VERSION=$(curl -s https://api.github.com/repos/tmux/tmux/releases/latest | jq -r '.tag_name') \
    && curl -LO https://github.com/tmux/tmux/releases/download/${TMUX_VERSION}/tmux-${TMUX_VERSION}.tar.gz \
    && tar -xzf tmux-${TMUX_VERSION}.tar.gz \
    && cd tmux-${TMUX_VERSION} \
    && ./configure \
    && make && make install \
    && cd .. && rm -rf tmux-${TMUX_VERSION}*

# --- 4. Install Ghostty Terminfo ---
# This allows TERM=xterm-ghostty to be recognized inside the container
COPY ./ghostty.terminfo /tmp/ghostty.terminfo
RUN tic -x /tmp/ghostty.terminfo \
    && rm /tmp/ghostty.terminfo

ENV TERM=xterm-ghostty

# --- 5. Setup User and Permissions ---
ARG USERNAME=embe221ed
ARG USER_UID=1337
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME -s /usr/bin/zsh \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# --- 6. Setup Repositories ---
RUN mkdir -p /opt/tools
WORKDIR /opt
RUN git clone https://github.com/embe221ed/scripts /opt/scripts \
    && git clone https://github.com/embe221ed/interdotensional /opt/tools/interdotensional \
    && chown -R $USERNAME:$USERNAME /opt/scripts /opt/tools

# --- 7. Language Managers & Python Environment (Installed as User) ---
USER $USERNAME
WORKDIR /home/$USERNAME
ENV HOME=/home/$USERNAME
ENV PYENV_ROOT="$HOME/.pyenv"
ENV PATH="$PYENV_ROOT/bin:$PYENV_ROOT/shims:$PATH"

# A. Oh My Zsh & Custom Plugins
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended \
    && git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions \
    && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# B. Install Pyenv
RUN curl https://pyenv.run | bash

# C. Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --profile minimal

# D. Install NVM
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# E. Install rbenv
RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv \
    && git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

# F. Install govman
RUN curl -sSL https://get.govman.dev/install.sh | bash && ~/.govman/bin/govman init --shell zsh

# G. Setup Python Version & pyenv-virtualenv for interdotensional
RUN pyenv install 3.12.13 \
    && pyenv global 3.12.13 \
    && pyenv virtualenv 3.12.13 venv \
    && PYENV_VERSION=venv python -m pip install --upgrade pip \
    && PYENV_VERSION=venv python -m pip install --no-cache-dir -r /opt/tools/interdotensional/requirements.txt \
    && PYENV_VERSION=venv python /opt/tools/interdotensional/generate.py

# --- 8. Configure Shell (.zshrc setup) ---

# A. Pyenv Login Configuration
RUN echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zprofile \
    && echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zprofile \
    && echo 'eval "$(pyenv init --path)"' >> ~/.zprofile

# B. OMZ Plugin Configuration (Forced cleanup)
RUN sed -i '/^plugins=(/c\plugins=(git vi-mode zsh-autosuggestions zsh-syntax-highlighting)' ~/.zshrc \
    && echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.zshrc \
    && echo 'export PATH="/opt/scripts:$PATH"' >> ~/.zshrc

# C. Tool Symlinks
RUN mkdir -p ~/.config \
    && ln -s /opt/scripts/configs/nvim ~/.config/nvim \
    && ln -sf /opt/scripts/configs/nvim/lua/languages.lua.sui /opt/scripts/configs/nvim/lua/languages.lua \
    && ln -sf /opt/tools/interdotensional/output/nvim/globals.lua /opt/scripts/configs/nvim/lua/globals.lua \
    && ln -sf /opt/tools/interdotensional/output/nvim/colors.lua /opt/scripts/configs/nvim/lua/ui/colors.lua \
    && ln -sf /opt/tools/interdotensional/output/tmux/.tmux.conf ~/.tmux.conf

# D. Zsh UI & Features
RUN echo 'set -o vi' >> ~/.zshrc \
    && echo 'export VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true' >> ~/.zshrc \
    && echo 'export VI_MODE_SET_CURSOR=true' >> ~/.zshrc

# E. Hooks & Initialization
RUN echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc \
    && echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc \
    && echo 'eval "$(pyenv init - zsh)"' >> ~/.zshrc \
    && echo 'eval "$(direnv hook zsh)"' >> ~/.zshrc \
    && echo 'source "$HOME/.cargo/env"' >> ~/.zshrc \
    && echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc \
    && echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.zshrc \
    && echo 'eval "$(~/.rbenv/bin/rbenv init - --no-rehash zsh)"' >> ~/.zshrc

CMD [ "/usr/bin/zsh" ]
