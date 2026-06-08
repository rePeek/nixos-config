{
  hostUsernames ? [ ],
  lib,
  ...
}:
{
  imports = [
    ./dank-material-shell.nix
    ./fonts.nix
    ./wayland.nix
  ];

  options.custom.desktop = {
    users = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = hostUsernames;
      defaultText = lib.literalExpression "mkHost usernames";
      description = "Users that receive the system desktop defaults through Home Manager.";
    };

    shell = {
      enable = lib.mkEnableOption "desktop shell profile";

      backend = lib.mkOption {
        type = lib.types.enum [ "dank-material-shell" ];
        default = "dank-material-shell";
        description = "Desktop shell implementation managed by the system profile.";
      };

      compositor = lib.mkOption {
        type = lib.types.enum [ "hyprland" ];
        default = "hyprland";
        description = "Wayland compositor used with the desktop shell.";
      };

      manageUserDefaults = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Inject default per-user shell configuration from the system module.";
      };
    };
  };
}
