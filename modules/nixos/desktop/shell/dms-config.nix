{
  pkgs,
  terminalCommand ? "",
  ...
}:
let
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
  settings = {
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

  clipboardSettings = { };

  session = {
    configVersion = 3;
    terminalOverride = terminalCommand;
  };

  homePackages = [ ];

  gtk = {
    font = {
      name = "Maple Mono";
      size = 12;
    };
    theme = {
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
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme.override { color = "black"; };
    };
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 24;
    };
  };

}
