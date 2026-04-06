{ pkgs, ... }:

{
  home.stateVersion = "25.11";
  programs.plasma = {
    enable = true;
    shortcuts = {
      kwin.Overview = ["Meta" "Meta+Space" "Meta+W"];
    };
    configFile = {
      kwinrc."org.kde.kdecoration2".ButtonsOnLeft = "X";
      kwinrc."org.kde.kdecoration2".ButtonsOnRight = "";
      kwinrc.EdgeBarrier.EdgeBarrier = 0;
      kdeglobals.KDE.SingleClick = true;
      kded5rc.Module-device_automounter.autoload = false;

      # TODO where to install the file to
      kwinrc.Plugins.dynamic_workspacesEnabled = true;
    };
  };
}
