FROM phusion/baseimage:0.11

RUN install_clean \
 rsync file curl time wget git git-lfs tmux zsh sudo neovim unzip \
 software-properties-common cmake make gcc g++ python python3 gdb

# user setup
ARG luser=robo
ENV LUSER=${luser}

RUN groupadd -r ${LUSER} -g 901
RUN useradd -m -u 901 -r -g 901 -s /usr/bin/zsh ${LUSER}
RUN adduser ${LUSER} sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

CMD ["/sbin/my_init"]

ARG CACHEBUST=1

USER ${LUSER}
WORKDIR /home/${LUSER}
RUN mkdir -p /home/${LUSER}/code/configs
COPY --chown=901:901 ./ code/configs/
WORKDIR /home/${LUSER}/code/configs
RUN zsh -c 'for rem in $(git remote show); do [[ $rem != origin ]] && git remote rm $rem; done; return 0'
RUN git remote set-url origin https://gitlab.com/robobenklein/configs.git
RUN git remote add github https://github.com/robobenklein/configs.git
RUN git fetch --all
COPY zsh/skel-virus-robo.zsh /etc/skel/.zshrc
RUN /home/${LUSER}/code/configs/install -v
WORKDIR /home/${LUSER}
RUN touch ~/.z
RUN ZSH_THEME=p10k zsh -i -c -- '-zplg-scheduler burst || true'
