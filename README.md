
# Robo's linux (+unix) configs

| Sv | At |
|-|-|
| Shell | zsh |
| Shell Framework | Zinit |
| Shell theme | ZINC, Fishy |
| DE | Gnome + Pop Shell |
| CLI Editor | Vim (Neovim) |
| IDE | Atom (CodeRibbon) |
| Terminal | Tilix |
| Multiplexer | tmux |
| Audio | MPD, Picard, Jellyfin |
| Monitoring | htop, conky, Prometheus/Influx/Grafana |
| Mail | Mutt, Gmail, Thunderbird, Protonmail |
| Chat | Matrix, Keybase, Discord |
| Dotfile manager | Dotbot |
| Distro | Pop!\_OS (Ubuntu on servers, Debian derivatives elsewhere) |
| Containers | docker |
| Chroot | firejail |
| Games | Steam, Itch, Humble, Lutris |

### Docker

`robobenklein/home` is a docker container with a base system set up (phusion baseimage) that has general utilities and programs installed, along with the configs from this repo.

If you have docker and just want to try out these configs without changing anything on your machine,

```
docker pull robobenklein/home
docker run --rm -it robobenklein/home:latest zsh -i
# by default it starts without a powerline prompt,
# but if you have powerline fonts:
docker run --rm --env ZSH_THEME=zinc -it robobenklein/home:latest zsh -i
```
