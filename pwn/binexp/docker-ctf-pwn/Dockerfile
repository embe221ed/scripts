FROM pwntools/pwntools:stable

ENV TERM=xterm-256color

USER root

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    gdb \
    gdb-multiarch \
    git \
    tmux \
    vim \
    file \
    patchelf \
    strace \
    ltrace \
    binutils \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/pwndbg/pwndbg /opt/pwndbg \
    && chown -R pwntools:pwntools /opt/pwndbg

USER pwntools
RUN sudo chsh -s /bin/bash pwntools
WORKDIR /opt/pwndbg

RUN ./setup.sh

WORKDIR /home/pwntools
COPY .tmux.conf .

WORKDIR /home/pwntools/work
CMD [ "/bin/bash" ]
