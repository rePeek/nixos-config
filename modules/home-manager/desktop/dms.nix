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
  stylixColors = lib.attrByPath [ "lib" "stylix" "colors" "withHashtag" ] null config;
  stylixCursor = lib.attrByPath [ "stylix" "cursor" ] null config;
  stylixThemeEnabled = stylixColors != null;
  stylixColor = name: stylixColors.${name};

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

  dmsCursorSettings = {
    # cursorSettings is also an object replacement in DMS settings.
    theme = if stylixCursor == null then "default" else stylixCursor.name;
    size = if stylixCursor == null then 24 else stylixCursor.size;
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

  dmsStylixTheme = {
    id = "stylix";
    name = "Stylix";
    version = "1";
    author = "nixos-config";
    description = "Generated from the active Stylix Base16 palette.";
    light = {
      primary = stylixColor "base0D";
      primaryText = stylixColor "base00";
      primaryContainer = stylixColor "base02";
      primaryContainerText = stylixColor "base05";
      secondary = stylixColor "base0B";
      secondaryText = stylixColor "base00";
      secondaryContainer = stylixColor "base01";
      secondaryContainerText = stylixColor "base05";
      tertiary = stylixColor "base0E";
      tertiaryText = stylixColor "base00";
      tertiaryContainer = stylixColor "base01";
      tertiaryContainerText = stylixColor "base05";
      surface = stylixColor "base00";
      surfaceText = stylixColor "base05";
      surfaceVariant = stylixColor "base01";
      surfaceVariantText = stylixColor "base04";
      surfaceTint = stylixColor "base0D";
      background = stylixColor "base00";
      backgroundText = stylixColor "base05";
      outline = stylixColor "base03";
      outlineVariant = stylixColor "base02";
      surfaceContainerLowest = stylixColor "base00";
      surfaceContainerLow = stylixColor "base01";
      surfaceContainer = stylixColor "base01";
      surfaceContainerHigh = stylixColor "base02";
      surfaceContainerHighest = stylixColor "base02";
      surfaceBright = stylixColor "base00";
      surfaceDim = stylixColor "base01";
      inverseSurface = stylixColor "base07";
      inverseOnSurface = stylixColor "base00";
      inversePrimary = stylixColor "base0D";
      error = stylixColor "base08";
      errorText = stylixColor "base00";
      errorContainer = stylixColor "base01";
      errorContainerText = stylixColor "base08";
      warning = stylixColor "base0A";
      info = stylixColor "base0C";
    };
    dark = {
      primary = stylixColor "base0D";
      primaryText = stylixColor "base00";
      primaryContainer = stylixColor "base06";
      primaryContainerText = stylixColor "base00";
      secondary = stylixColor "base0B";
      secondaryText = stylixColor "base00";
      secondaryContainer = stylixColor "base06";
      secondaryContainerText = stylixColor "base00";
      tertiary = stylixColor "base0E";
      tertiaryText = stylixColor "base00";
      tertiaryContainer = stylixColor "base06";
      tertiaryContainerText = stylixColor "base00";
      surface = stylixColor "base07";
      surfaceText = stylixColor "base00";
      surfaceVariant = stylixColor "base06";
      surfaceVariantText = stylixColor "base01";
      surfaceTint = stylixColor "base0D";
      background = stylixColor "base07";
      backgroundText = stylixColor "base00";
      outline = stylixColor "base04";
      outlineVariant = stylixColor "base06";
      surfaceContainerLowest = stylixColor "base07";
      surfaceContainerLow = stylixColor "base06";
      surfaceContainer = stylixColor "base06";
      surfaceContainerHigh = stylixColor "base05";
      surfaceContainerHighest = stylixColor "base04";
      surfaceBright = stylixColor "base06";
      surfaceDim = stylixColor "base07";
      inverseSurface = stylixColor "base00";
      inverseOnSurface = stylixColor "base07";
      inversePrimary = stylixColor "base0D";
      error = stylixColor "base08";
      errorText = stylixColor "base00";
      errorContainer = stylixColor "base06";
      errorContainerText = stylixColor "base00";
      warning = stylixColor "base0A";
      info = stylixColor "base0C";
    };
  };
in
{
  imports = [
    inputs.dms.homeModules.dank-material-shell
  ];

  home = {
    packages = [ ];

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

  xdg.configFile = lib.mkIf stylixThemeEnabled {
    "DankMaterialShell/themes/stylix/theme.json".text = builtins.toJSON dmsStylixTheme + "\n";
  };

  programs.dank-material-shell = {
    enable = lib.mkDefault true;
    dgop.package = lib.mkDefault pkgsUnstable.dgop;
    quickshell.package = lib.mkDefault quickshellPackage;
    systemd.enable = lib.mkDefault false;
    settings = lib.mkDefault (
      {
        configVersion = 11;

        currentThemeCategory = if stylixThemeEnabled then "custom" else "generic";
        currentThemeName = if stylixThemeEnabled then "custom" else "blue";

        useAutoLocation = true;
        popupTransparency = 0.92;
        cornerRadius = 12;
        systemTrayIconTintMode = "primary";

        clockDateFormat = "ddd d";
        lockDateFormat = "dddd, MMMM d";

        barConfigs = [ bottomMainBar ];

        cursorSettings = dmsCursorSettings;

        fontFamily = "Maple Mono NF CN";
        monoFontFamily = "Maple Mono NF CN";
        terminalsAlwaysDark = false;
        matugenTemplateGhostty = false;
        customPowerActionLogout = "uwsm stop";
      }
      // lib.optionalAttrs stylixThemeEnabled {
        customThemeFile = "${config.xdg.configHome}/DankMaterialShell/themes/stylix/theme.json";
      }
    );
    clipboardSettings = lib.mkDefault { };
    # DMS mutates session.json at runtime; keeping it as an HM-managed stateFile
    # causes activation conflicts once a real user-owned file exists.
    session = lib.mkForce { };
  };
}
