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
  terminal = config.custom.desktop.components.terminal;

  dmsEnabled = config.custom.desktop.enable && cfg.enable && cfg.backend == "dank-material-shell";
  desktopUsers = config.custom.desktop.users;
  primaryDesktopUser = if desktopUsers == [ ] then null else builtins.head desktopUsers;
  quickshellPackage = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;
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
        assertion = cfg.compositor == "hyprland";
        message = "custom.desktop.shell.compositor currently only supports hyprland.";
      }
      {
        assertion = terminal.enable;
        message = "custom.desktop.shell requires custom.desktop.components.terminal.enable.";
      }
      {
        assertion = primaryDesktopUser != null;
        message = "custom.desktop.shell requires at least one custom.desktop.users entry.";
      }
    ];

    programs.dank-material-shell = {
      enable = true;
      dgop.package = pkgsUnstable.dgop;
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
