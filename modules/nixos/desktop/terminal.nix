# Terminal defaults shared with desktop user profiles.
{
  config,
  lib,
  ...
}:

let
  cfg = config.custom.desktop.terminal;
in
{
  options.custom.desktop.terminal = {
    enable = lib.mkEnableOption "terminal defaults" // {
      default = true;
    };

    package = lib.mkOption {
      type = lib.types.enum [ "kitty" ];
      default = "kitty";
      description = "Terminal profile to enable for desktop users.";
    };

    command = lib.mkOption {
      type = lib.types.str;
      default = "kitty";
      description = "Terminal command used by desktop shell key bindings.";
    };

    desktopFile = lib.mkOption {
      type = lib.types.str;
      default = "kitty.desktop";
      description = "Desktop file used by terminal picker defaults.";
    };

    manageUserDefaults = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Apply terminal defaults in desktop Home Manager users.";
    };
  };

  config = lib.mkIf (config.custom.desktop.enable && cfg.enable) { };
}
