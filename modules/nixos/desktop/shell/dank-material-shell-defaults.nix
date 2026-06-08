{
  pkgs,
  terminalCommand ? "",
  ...
}:
{
  settings = {
    configVersion = 11;
    currentThemeName = "blue";
    currentThemeCategory = "generic";
    customThemeFile = "";
    matugenScheme = "scheme-tonal-spot";
    matugenContrast = 0;
    runUserMatugenTemplates = true;
    runDmsMatugenTemplates = true;
    wallpaperDynamicTheming = true;

    popupTransparency = 0.92;
    dockTransparency = 1.0;
    widgetBackgroundColor = "sch";
    widgetColorMode = "default";
    buttonColorMode = "primary";
    controlCenterTileColorMode = "primary";
    cornerRadius = 12;

    use24HourClock = true;
    useFahrenheit = false;
    windSpeedUnit = "kmh";
    nightModeEnabled = false;

    showLauncherButton = true;
    showWorkspaceSwitcher = true;
    showFocusedWindow = true;
    showWeather = true;
    showMusic = true;
    showClipboard = true;
    showCpuUsage = true;
    showMemUsage = true;
    showCpuTemp = true;
    showGpuTemp = true;
    showSystemTray = true;
    showClock = true;
    showNotificationButton = true;
    showBattery = true;
    showControlCenterButton = true;

    controlCenterShowNetworkIcon = true;
    controlCenterShowBluetoothIcon = true;
    controlCenterShowAudioIcon = true;
    controlCenterShowVpnIcon = true;
    controlCenterShowScreenSharingIcon = true;

    showWorkspaceIndex = false;
    showWorkspaceName = false;
    showWorkspacePadding = false;
    workspaceDragReorder = true;
    groupWorkspaceApps = true;
    runningAppsCompactMode = true;
    runningAppsCurrentWorkspace = true;
    clockCompactMode = false;
    focusedWindowCompactMode = false;
    clockDateFormat = "ddd d";
    lockDateFormat = "dddd, MMMM d";

    barConfigs = [
      {
        id = "default";
        name = "Main Bar";
        enabled = true;
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
        spacing = 4;
        innerPadding = 4;
        bottomGap = 0;
        transparency = 1.0;
        widgetTransparency = 1.0;
        squareCorners = false;
        noBackground = false;
        maximizeWidgetIcons = false;
        maximizeWidgetText = false;
        removeWidgetPadding = false;
        widgetPadding = 8;
        gothCornersEnabled = false;
        gothCornerRadiusOverride = false;
        gothCornerRadiusValue = 12;
        borderEnabled = false;
        borderColor = "surfaceText";
        borderOpacity = 1.0;
        borderThickness = 1;
        widgetOutlineEnabled = false;
        widgetOutlineColor = "primary";
        widgetOutlineOpacity = 1.0;
        widgetOutlineThickness = 1;
        fontScale = 1.0;
        iconScale = 1.0;
        autoHide = false;
        autoHideStrict = false;
        autoHideDelay = 250;
        showOnWindowsOpen = false;
        openOnOverview = false;
        visible = true;
        popupGapsAuto = true;
        popupGapsManual = 4;
        maximizeDetection = true;
        useOverlayLayer = false;
        scrollEnabled = true;
        scrollXBehavior = "column";
        scrollYBehavior = "workspace";
        shadowIntensity = 0;
        shadowOpacity = 60;
        shadowColorMode = "default";
        shadowCustomColor = "#000000";
        clickThrough = false;
      }
    ];

    appLauncherViewMode = "list";
    spotlightModalViewMode = "list";
    browserPickerViewMode = "grid";
    appPickerViewMode = "grid";
    launcherStyle = "full";
    dankLauncherV2Size = "compact";
    networkPreference = "auto";

    iconTheme = "System Default";
    cursorSettings = {
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

    launcherLogoMode = "apps";
    fontFamily = "Maple Mono NF CN";
    monoFontFamily = "Maple Mono NF CN";
    fontWeight = 400;
    fontScale = 1.0;
    gtkThemingEnabled = false;
    qtThemingEnabled = false;
    syncModeWithPortal = true;
    terminalsAlwaysDark = true;
    matugenTemplateGhostty = false;
    matugenTemplateKitty = true;

    showDock = false;
    notificationOverlayEnabled = false;
    notificationTimeoutLow = 5000;
    notificationTimeoutNormal = 5000;
    notificationTimeoutCritical = 0;

    powerMenuActions = [
      "reboot"
      "logout"
      "poweroff"
      "lock"
      "suspend"
      "restart"
    ];
    powerMenuDefaultAction = "logout";
    screenPreferences = { };
  };

  clipboardSettings = { };

  session = {
    configVersion = 3;
    isLightMode = false;
    terminalOverride = terminalCommand;
    doNotDisturb = false;
    weatherLocation = "New York, NY";
    weatherCoordinates = "40.7128,-74.0060";
    pinnedApps = [ ];
    barPinnedApps = [ ];
    selectedGpuIndex = 0;
    nvidiaGpuTempEnabled = false;
    nonNvidiaGpuTempEnabled = false;
    enabledGpuPciIds = [ ];
    wallpaperPath = "";
    wallpaperCyclingEnabled = false;
    wallpaperCyclingMode = "interval";
    wallpaperCyclingInterval = 300;
    wallpaperCyclingTime = "06:00";
    lastBrightnessDevice = "";
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
