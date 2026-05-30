{ pkgs, lib, ... }:

let
  mkLocalKWinScript = {
    pluginId,
    src,
    pname ? pluginId,
    version ? "local",
  }:
    pkgs.runCommandLocal "${pname}-${version}" { } ''
      mkdir -p "$out/share/kwin/scripts/${pluginId}"
      cp -R ${src}/* "$out/share/kwin/scripts/${pluginId}/"
    '';

  dynamicWorkspaces = mkLocalKWinScript {
    pluginId = "dynamic_workspaces";
    src = ./vendor/kwin-scripts/dynamic_workspaces;
    pname = "dynamic-workspaces";
    version = "3.2.0";
  };

  virtualDesktopsOnlyOnPrimary = mkLocalKWinScript {
    pluginId = "virtual-desktops-only-on-primary";
    src = ./vendor/kwin-scripts/virtual-desktops-only-on-primary;
    pname = "virtual-desktops-only-on-primary";
    version = "0.4.5";
  };

  defaultFavoriteApps = [
    {
      id = "files";
      name = "Files";
      launcher = "applications:org.kde.dolphin.desktop";
      command = "gtk-launch org.kde.dolphin";
    }
    {
      id = "browser";
      name = "Browser";
      launcher = "preferred://browser";
      command = "kioclient5 exec preferred://browser --new-window";
    }
    {
      id = "terminal";
      name = "Tilix";
      launcher = "applications:com.gexperts.Tilix.desktop";
      command = "tilix";
    }
  ];

  # Optional per-machine favorites file. This file intentionally lives outside
  # the repo, so a machine can keep its own dock/shortcut choices without
  # changing shared config. With flakes, reading an arbitrary local file requires
  # an impure evaluation, e.g.
  #
  #   PLASMA_FAVORITES_FILE=$HOME/.config/plasma-favorites.nix \
  #     home-manager switch --flake . --impure
  #
  # If no local file is available, the default list above is used.
  localFavoritesPathString =
    let
      explicit = builtins.getEnv "PLASMA_FAVORITES_FILE";
      home = builtins.getEnv "HOME";
    in
      if explicit != "" then explicit
      else if home != "" then "${home}/.config/plasma-favorites.nix"
      else "";

  localFavoritesPath =
    if localFavoritesPathString == ""
    then null
    else /. + localFavoritesPathString;

  localFavoritesRaw =
    if localFavoritesPath == null || !(builtins.pathExists localFavoritesPath)
    then { }
    else import localFavoritesPath;

  localFavorites =
    if builtins.isList localFavoritesRaw
    then { favoriteApps = localFavoritesRaw; }
    else localFavoritesRaw;

  favoriteAppOverrides = localFavorites.appOverrides or { };

  mergeFavoriteApp = app:
    app // (
      if builtins.hasAttr app.id favoriteAppOverrides
      then favoriteAppOverrides.${app.id}
      else { }
    );

  favoriteApps =
    if localFavorites ? favoriteApps
    then localFavorites.favoriteApps
    else (map mergeFavoriteApp defaultFavoriteApps) ++ (localFavorites.extraFavoriteApps or [ ]);

  favoriteLaunchers = map (app: app.launcher) favoriteApps;

  favoriteHotkeys =
    lib.listToAttrs
      (lib.imap0
        (index: app: {
          name = "favorite-${toString (index + 1)}";
          value = {
            name = "Favorite ${toString (index + 1)} - ${app.name}";
            key = "Ctrl+Meta+${toString (index + 1)}";
            command = app.command;
          };
        })
        favoriteApps);
in
{
  home.stateVersion = "25.11";

  home.packages = [
    dynamicWorkspaces
    virtualDesktopsOnlyOnPrimary
    pkgs.plasma-panel-colorizer
  ] ++ lib.optional (pkgs ? kdePackages && pkgs.kdePackages ? qttools) pkgs.kdePackages.qttools;

  programs.plasma = {
    enable = true;
    overrideConfig = true;

    session = {
      sessionRestore.restoreOpenApplicationsOnLogin = "startWithEmptySession";
    };

    kwin = {
      edgeBarrier = 0;
      cornerBarrier = false;
      titlebarButtons.left = [ "close" ];
      titlebarButtons.right = [ ];
      virtualDesktops.rows = 1;
      effects.desktopSwitching.animation = "slide";
      effects.windowOpenClose.animation = "glide";
    };

    shortcuts = {
      kwin = {
        Overview = [ "Meta" "Meta+Space" "Meta+W" ];
        "Grid View" = "Meta+G";
        "Switch One Desktop to the Left" = [ "Meta+PgUp" "Meta+Ctrl+Left" ];
        "Switch One Desktop to the Right" = [ "Meta+PgDown" "Meta+Ctrl+Right" ];
      };

      ksmserver = {
        "Lock Session" = "Meta+Escape";
      };
    };

    hotkeys.commands = favoriteHotkeys;

    panels = [
      {
        screen = 0;
        location = "left";
        floating = false;
        opacity = "translucent";
        height = 64;
        lengthMode = "fill";
        hiding = "dodgewindows";

        widgets = [
          {
            # Panel Colorizer is installed from nixpkgs and inserted into the left
            # panel so the panel appearance can be made fully transparent instead
            # of relying only on Plasma's partial/adaptive panel opacity.
            #
            # Plasma Manager also knows this plasmoid by plugin id, so leaving it
            # in the panel list keeps the custom widget part reviewable in Nix.
            name = "luisbocanegra.panel.colorizer";
            config.General = {
              globalSettings = builtins.toJSON {
                nativePanel.background = {
                  enabled = false;
                  opacity = 0.0;
                  shadow = false;
                };
                panel.normal.enabled = false;
              };
              hideWidget = true;
            };
          }

          {
            iconTasks = {
              iconsOnly = true;
              launchers = favoriteLaunchers;

              appearance = {
                showTooltips = true;
                highlightWindows = true;
                indicateAudioStreams = true;
                fill = true;
                iconSpacing = "small";
              };

              # TODO: version dependent?
              settings.General.wheelEnabled = "TaskOnly";

              behavior = {
                grouping = {
                  method = "byProgramName";
                  clickAction = "showTooltips";
                };
                sortingMethod = "manually";
                middleClickAction = "newInstance";
                #wheel.switchBetweenTasks = false;
                showTasks = {
                  onlyInCurrentScreen = false;
                  onlyInCurrentDesktop = false;
                  onlyInCurrentActivity = false;
                  onlyMinimized = false;
                };
                unhideOnAttentionNeeded = true;
              };
            };
          }
        ];
      }

      {
        screen = 0;
        location = "top";
        floating = false;
        opacity = "opaque";
        height = 32;
        lengthMode = "fill";

        widgets = [
          {
            pager.general = {
              showWindowOutlines = true;
              showApplicationIconsOnWindowOutlines = false;
              showOnlyCurrentScreen = true;
              navigationWrapsAround = false;
              displayedText = "none";
              selectingCurrentVirtualDesktop = "doNothing";
            };
          }

          {
            panelSpacer = {};
          }

          {
            digitalClock = {
              date = {
                enable = true;
                format.custom = "ddd MMM d";
                position = "besideTime";
              };
              time = {
                format = "24h";
                showSeconds = "always";
              };
              calendar = {
                showWeekNumbers = true;
              };
            };
          }

          {
            panelSpacer = {};
          }

          {
            systemTray = {
              icons = {
                spacing = "small";
                scaleToFit = false;
              };
              items.showAll = false;
            };
          }

          "org.kde.plasma.lock_logout"
        ];
      }
    ];

    configFile = {
      kdeglobals.KDE.SingleClick = true;
      kded5rc.Module-device_automounter.autoload = false;
      kded6rc.Module-device_automounter.autoload = false;

      kwinrc.Plugins.dynamic_workspacesEnabled = true;
      kwinrc.Plugins."virtual-desktops-only-on-primaryEnabled" = true;

      kwinrc."Script-dynamic_workspaces" = {
        keepEmptyMiddleDesktops = false;
      };

      kwinrc."Script-virtual-desktops-only-on-primary" = {
        primaryOutputIndex = 0;
        numberOfScreens = 3;
      };
    };
  };
}
