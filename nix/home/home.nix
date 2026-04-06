{ pkgs, ... }:

{
  home.stateVersion = "25.11";
  programs.plasma = {
    enable = true;
    shortcuts = {
      kwin.Overview = ["Meta" "Meta+Space" "Meta+W"];
    };
  };
}
