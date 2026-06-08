{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.custom.desktop.shell;
  desktopUsers = config.custom.desktop.users;
  primaryDesktopUser = if desktopUsers == [ ] then null else builtins.head desktopUsers;
  dmsHyprlandSession =
    cfg.enable && cfg.backend == "dank-material-shell" && cfg.compositor == "hyprland";
in
{
  imports = [
    inputs.dms.nixosModules.greeter
  ];

  config = lib.mkIf config.custom.service.desktop.enable (
    lib.mkMerge [
      {
        services.greetd = {
          enable = true;
          settings.default_session.user = lib.mkDefault "greeter";
        };
      }

      (lib.mkIf dmsHyprlandSession {
        programs.dank-material-shell.greeter = {
          enable = true;
          compositor.name = "hyprland";
        }
        // lib.optionalAttrs (primaryDesktopUser != null) {
          configHome = "/home/${primaryDesktopUser}";
        };
      })

      (lib.mkIf (!dmsHyprlandSession) {
        services.greetd.settings.default_session.command =
          "${pkgs.tuigreet}/bin/tuigreet --time --asterisks --remember --remember-session --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions";
      })
    ]
  );
}
