{
  config,
  inputs,
  lib,
  pkgs,
  pkgsUnstable,
  ...
}:
let
  terminalCommand = config.home.sessionVariables.TERMINAL or "kitty";
  quickshellPackage = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;

  bottomMainBar = {
    id = "default";
    name = "Main Bar";
    enabled = true;
    # DMS replaces barConfigs as a whole. Keep only the fields needed to
    # preserve the default bar contents while moving it to the bottom.
    position = 1;
    screenPreferences = [ "all" ];
    showOnLastDisplay = true;
    leftWidgets = [
      "launcherButton"
      "workspaceSwitcher"
      "focusedWindow"
    ];
    centerWidgets = [
      "music"
      "clock"
      "weather"
    ];
    rightWidgets = [
      "systemTray"
      "clipboard"
      "cpuUsage"
      "memUsage"
      "notificationButton"
      "battery"
      "controlCenterButton"
    ];
  };

  bibataCursorSettings = {
    # cursorSettings is also an object replacement in DMS settings.
    theme = "Bibata-Modern-Ice";
    size = 24;
    niri = {
      hideWhenTyping = false;
      hideAfterInactiveMs = 0;
    };
    hyprland = {
      hideOnKeyPress = false;
      hideOnTouch = false;
      inactiveTimeout = 0;
    };
    dwl.cursorHideTimeout = 0;
    mango.cursorHideTimeout = 0;
  };
in
{
  imports = [
    inputs.dms.homeModules.dank-material-shell
  ];

  home = {
    packages = [ ];
    pointerCursor = lib.mkDefault {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 24;
    };

    sessionVariables.WINEDLLOVERRIDES = lib.mkDefault "winemenubuilder.exe=d";

    activation.migrateDmsSessionState = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
      sessionFile="${config.xdg.stateHome}/DankMaterialShell/session.json"

      if [ -L "$sessionFile" ]; then
        target="$(readlink "$sessionFile")"
        if [[ "$target" == /nix/store/* ]]; then
          run rm "$sessionFile"
          if [ -f "$sessionFile.bkp" ]; then
            run cp "$sessionFile.bkp" "$sessionFile"
          fi
        fi
      fi
    '';
  };

  programs.home-manager.enable = lib.mkDefault true;

  programs.dank-material-shell = {
    enable = lib.mkDefault true;
    dgop.package = lib.mkDefault pkgsUnstable.dgop;
    quickshell.package = lib.mkDefault quickshellPackage;
    systemd.enable = lib.mkDefault true;
    settings = lib.mkDefault {
      configVersion = 11;

      currentThemeName = "blue";

      useAutoLocation = true;
      popupTransparency = 0.92;
      cornerRadius = 12;

      clockDateFormat = "ddd d";
      lockDateFormat = "dddd, MMMM d";

      barConfigs = [ bottomMainBar ];

      cursorSettings = bibataCursorSettings;

      fontFamily = "Maple Mono NF CN";
      monoFontFamily = "Maple Mono NF CN";
      terminalsAlwaysDark = true;
      matugenTemplateGhostty = false;
    };
    clipboardSettings = lib.mkDefault { };
    session = lib.mkDefault {
      configVersion = 3;
      terminalOverride = terminalCommand;
    };
  };

  gtk = {
    enable = lib.mkDefault true;
    font = lib.mkDefault {
      name = "Maple Mono";
      size = 12;
    };
    theme = lib.mkDefault {
      name = "Colloid-Green-Dark-Gruvbox";
      package = pkgs.colloid-gtk-theme.override {
        colorVariants = [ "dark" ];
        themeVariants = [ "green" ];
        tweaks = [
          "gruvbox"
          "rimless"
          "float"
        ];
      };
    };
    iconTheme = lib.mkDefault {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme.override { color = "black"; };
    };
    cursorTheme = lib.mkDefault {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 24;
    };
  };
}
