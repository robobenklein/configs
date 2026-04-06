
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

requires: nix, home-manager already installed

`home-manager build --flake .`

`home-manager switch --flake .`
