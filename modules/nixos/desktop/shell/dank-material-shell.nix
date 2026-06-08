{
  config,
  inputs,
  lib,
  pkgs,
  pkgsUnstable,
  ...
}:
let
  cfg = config.custom.desktop.shell;
  terminal = config.custom.desktop.addons.terminal;
  terminalCommand = terminal.command;
  dmsConfig = import ./dms-config.nix {
    inherit
      lib
      pkgs
      pkgsUnstable
      terminalCommand
      ;
  };

  dmsEnabled = config.custom.desktop.enable && cfg.enable && cfg.backend == "dank-material-shell";
  dmsServicePath = [
    quickshellPackage
  ]
  ++ lib.optionals config.custom.features.audio.enable [
    pkgs.pulseaudio
  ];

  desktopUsers = config.custom.desktop.users;
  primaryDesktopUser = if desktopUsers == [ ] then null else builtins.head desktopUsers;
  startDmsSession = pkgs.writeShellScript "start-dms-session" ''
    sleep 1
    systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP XDG_SESSION_TYPE HYPRLAND_INSTANCE_SIGNATURE QT_QPA_PLATFORM
    dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP XDG_SESSION_TYPE HYPRLAND_INSTANCE_SIGNATURE QT_QPA_PLATFORM
    systemctl --user reset-failed dms.service
    systemctl --user start dms.service
  '';
  quickshellPackage = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;
  hyprlandConfig = import ./hyprland-config.nix {
    inherit
      inputs
      pkgs
      terminalCommand
      startDmsSession
      ;
  };

  userDesktopModule =
    username:
    let
      user = config.users.users.${username} or { };
      homeDirectory = user.home or "/home/${username}";
    in
    { config, lib, ... }:
    {
      imports = [
        inputs.dms.homeModules.dank-material-shell
      ];

      home = {
        username = lib.mkDefault username;
        homeDirectory = lib.mkDefault homeDirectory;
        stateVersion = lib.mkDefault "25.11";
        packages = dmsConfig.homePackages;
        pointerCursor = lib.mkDefault dmsConfig.gtk.cursorTheme;
      };

      programs.home-manager.enable = lib.mkDefault true;

      programs.dank-material-shell = {
        enable = lib.mkDefault true;
        dgop.package = lib.mkDefault pkgsUnstable.dgop;
        quickshell.package = lib.mkDefault quickshellPackage;
        systemd.enable = lib.mkDefault false;
        settings = lib.mkDefault dmsConfig.settings;
        clipboardSettings = lib.mkDefault dmsConfig.clipboardSettings;
      };

      gtk = {
        enable = lib.mkDefault true;
        font = lib.mkDefault dmsConfig.gtk.font;
        theme = lib.mkDefault dmsConfig.gtk.theme;
        iconTheme = lib.mkDefault dmsConfig.gtk.iconTheme;
        cursorTheme = lib.mkDefault dmsConfig.gtk.cursorTheme;
      };

      home.sessionVariables.WINEDLLOVERRIDES = lib.mkDefault "winemenubuilder.exe=d";

      home.activation.migrateDmsSessionState = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
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

      xdg.configFile = hyprlandConfig.xdgConfigFile;
    };
in
{
  imports = [
    inputs.dms.nixosModules.dank-material-shell
    inputs.dms.nixosModules.greeter
  ];

  config = lib.mkIf dmsEnabled {
    assertions = [
      {
        assertion = cfg.compositor == "hyprland";
        message = "custom.desktop.shell.compositor currently only supports hyprland.";
      }
      {
        assertion = terminal.enable;
        message = "custom.desktop.shell requires custom.desktop.addons.terminal.enable.";
      }
    ];

    programs.dank-material-shell = {
      enable = true;
      dgop.package = pkgsUnstable.dgop;
      systemd.enable = true;
      quickshell.package = quickshellPackage;
      greeter = {
        enable = true;
        compositor.name = "hyprland";
      }
      // lib.optionalAttrs (primaryDesktopUser != null) {
        configHome = "/home/${primaryDesktopUser}";
      };
    };

    services.greetd = {
      enable = true;
      settings.default_session.user = lib.mkDefault "greeter";
    };

    systemd.user.services.dms = {
      environment.QT_QPA_PLATFORM = "wayland";
      serviceConfig = {
        ExecStart = lib.mkForce "${config.programs.dank-material-shell.package}/bin/dms run";
        UnsetEnvironment = [
          "QT_IM_MODULE"
          "QT_PLUGIN_PATH"
          "QML2_IMPORT_PATH"
        ];
      };
      path = dmsServicePath;
    };

    services.displayManager.sessionPackages = [
      hyprlandConfig.sessionPackage
    ];
    services.displayManager.defaultSession = "hyprland-dms";

    home-manager.users = lib.mkIf cfg.manageUserDefaults (
      lib.genAttrs desktopUsers (username: {
        imports = [
          (userDesktopModule username)
        ];
      })
    );
  };
}
