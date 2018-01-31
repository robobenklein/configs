FROM phusion/baseimage:0.10.0

RUN apt-get update
RUN apt-get -y install \
      rsync curl wget git tmux zsh vim

RUN groupadd -r robo -g 901 && useradd -m -u 901 -r -g 901 robo

CMD ["/sbin/my_init"]

RUN apt-get clean

ARG CACHEBUST=1

USER robo
WORKDIR /home/robo
RUN bash -c "$(curl -fsSL https://raw.githubusercontent.com/robobenklein/configs/master/provision.sh)"

