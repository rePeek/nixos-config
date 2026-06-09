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

  dmsEnabled = config.custom.desktop.enable && cfg.enable && cfg.backend == "dank-material-shell";
  desktopUsers = config.custom.desktop.users;
  primaryDesktopUser = if desktopUsers == [ ] then null else builtins.head desktopUsers;
  quickshellPackage = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;
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
        message = "custom.desktop.shell requires custom.desktop.addons.terminal.enable.";
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
