
# work in progress

first time using nix flakes (and nix outside of nixOS at all...)

getting a KDE configuration I'm happy with declaratively defined

- https://github.com/maurges/dynamic_workspaces
  - vertical/multi-row support?
- https://github.com/Ubiquitine/virtual-desktops-only-on-primary
  - fix multi-monitor desktop support
  - differences compared to newly merged upstream?
    - (I'm currently on plasma 6.3 - would backport into these configs anyways)

# usage

requires: nix, home-manager already installed, qdbus CLI

`nix run home-manager build --flake .`

`nix run home-manager switch --flake .`


# TODOs

- Top left corner:
  - hot corner is broken? is it because VM?
- Dock:
  - Super+N works, but need Ctrl+Super+N to "open new window/instance"
  - Scroll wheel should only cycle through the hovered app's windows
  - Hidden transparent widget
    - found on the KDE store: https://store.kde.org/p/2107649 but how do I import it in home-manager/plasma-manager?
    - Is there an even easier option? (does plasma-manager expose colors as config?)
  - Still possibly open to other dock/panel alteratives
- Top center date:
  - how to get rid of the `|` separator
- Top right:
  - "Application Launcher" tap target too small
  - Something else that gives power / login controls?
- In overview mode:
  - Scroll wheel to switch between desktops
  - Possible to still show dock / application list? (not too important)
- Load kwin scripts
  - dynamic workspaces seems to work well, haven't tried the workspaces-only-on-primary yet
  - compare keeping my own copy in this repo vs. a submodule
