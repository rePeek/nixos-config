{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.desktop.shell;

  dmsEnabled = config.custom.desktop.enable && cfg.enable;
  desktopUsers = config.custom.desktop.users;
  primaryDesktopUser = if desktopUsers == [ ] then null else builtins.head desktopUsers;
  dmsCommand = lib.getExe config.programs.dank-material-shell.package;
  quickshellPackage = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;
  dmsIdleInhibitCommand =
    state:
    pkgs.writeShellScript "dms-idle-inhibit-${state}" ''
      export PATH=${lib.makeBinPath [ quickshellPackage ]}
      exec ${dmsCommand} ipc call inhibit ${state}
    '';
  cursorTheme = lib.attrByPath [ "stylix" "cursor" ] {
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;
  } config;
  cursorName = cursorTheme.name;
  cursorSize = toString cursorTheme.size;
  uwsmHyprlandCommand = pkgs.writeShellScriptBin "Hyprland" ''
    exec /run/current-system/sw/bin/start-hyprland "$@"
  '';
in
{
  imports = [
    inputs.dms.nixosModules.dank-material-shell
    inputs.dms.nixosModules.greeter
  ];

  config = lib.mkIf dmsEnabled {
    assertions = [
      {
        assertion = primaryDesktopUser != null;
        message = "custom.desktop.shell requires at least one custom.desktop.users entry.";
      }
    ];

    programs.dank-material-shell = {
      enable = true;
      dgop.package = pkgs.dgop;
      systemd.enable = false;
      quickshell.package = quickshellPackage;
      greeter = {
        enable = true;
        compositor = {
          name = "hyprland";
          customConfig = ''
            env = DMS_RUN_GREETER,1
            env = XCURSOR_THEME,${cursorName}
            env = XCURSOR_SIZE,${cursorSize}
            env = HYPRCURSOR_THEME,${cursorName}
            env = HYPRCURSOR_SIZE,${cursorSize}

            misc {
                disable_hyprland_logo = true
            }

            exec-once = hyprctl setcursor ${cursorName} ${cursorSize}
          '';
        };
      }
      // lib.optionalAttrs (primaryDesktopUser != null) {
        configHome = "/home/${primaryDesktopUser}";
      };
    };

    # Gamepads do not necessarily reset the compositor's idle timer. Keep the
    # display awake while at least one GameMode client is active.
    programs.gamemode.settings.custom = lib.mkIf config.custom.desktop.gaming.enable {
      start = "${dmsIdleInhibitCommand "enable"}";
      end = "${dmsIdleInhibitCommand "disable"}";
    };

    environment.systemPackages = [
      cursorTheme.package
    ];

    services.greetd = {
      enable = true;
      settings.default_session.user = lib.mkDefault "greeter";
    };
    systemd.services.greetd.environment = {
      XCURSOR_THEME = cursorName;
      XCURSOR_SIZE = cursorSize;
      HYPRCURSOR_THEME = cursorName;
      HYPRCURSOR_SIZE = cursorSize;
      XCURSOR_PATH = "${cursorTheme.package}/share/icons";
    };
    services.displayManager.defaultSession = lib.mkDefault "hyprland-uwsm";

    programs.uwsm.waylandCompositors.hyprland = lib.mkIf (primaryDesktopUser != null) {
      prettyName = "Hyprland";
      comment = "Hyprland compositor managed by UWSM";
      # UWSM derives XDG_CURRENT_DESKTOP from the executable basename.
      # Keep that as Hyprland while still entering through start-hyprland.
      binPath = lib.mkForce "${uwsmHyprlandCommand}/bin/Hyprland";
      extraArgs = lib.mkForce [
        "--"
        "-c"
        "/home/${primaryDesktopUser}/.config/hypr/hyprland.lua"
      ];
    };
  };
}
