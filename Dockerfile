FROM phusion/baseimage:0.10.0

RUN apt-get update
RUN apt-get -y install \
      rsync file curl wget git tmux zsh sudo vim

# user setup
ARG luser=robo
ENV LUSER=${luser}

RUN groupadd -r ${LUSER} -g 901
RUN useradd -m -u 901 -r -g 901 ${LUSER}
RUN adduser ${LUSER} sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

CMD ["/sbin/my_init"]

# remove any of the apt temporary files
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Enable the SSH service on this container
#RUN rm -f /etc/service/sshd/down

ARG CACHEBUST=1

USER ${LUSER}
WORKDIR /home/${LUSER}
COPY provision.sh /tmp/
RUN bash /tmp/provision.sh

