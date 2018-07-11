FROM phusion/baseimage:0.10.1

RUN install_clean \
 rsync file curl time wget git tmux zsh sudo vim unzip \
 software-properties-common cmake make gcc g++ python python3 gdb

RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash
RUN install_clean git-lfs

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
RUN for rem in $(git remote show); do git remote rm $rem; done
RUN git remote add origin https://gitlab.com/robobenklein/configs.git
RUN git remote add github https://github.com/robobenklein/configs.git
RUN git fetch --all
COPY zsh/skel-virus-robo.zsh /etc/skel/.zshrc
RUN /home/${LUSER}/code/configs/install -v
RUN touch ~/.z
RUN zsh -i -c 'sleep 2; -zplg-scheduler following'
