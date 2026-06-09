# Terminal addon with matching desktop defaults.
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.custom.desktop.addons.terminal;
  desktopUsers = config.custom.desktop.users;

  mimeDefaults = {
    terminal = [ cfg.desktopFile ];
  };

  userModule = {
    home = {
      packages = lib.mkIf (cfg.package == "kitty") [
        pkgs.kitty
      ];

      sessionVariables.TERMINAL = lib.mkDefault cfg.command;
    };

    programs.kitty = lib.mkIf (cfg.package == "kitty") {
      enable = lib.mkDefault true;
      package = lib.mkDefault null;
      themeFile = lib.mkDefault "GitHub_Light";
    };

    xdg.configFile."xdg-terminals.list".text = lib.mkDefault ''
      ${cfg.desktopFile}
    '';

    xdg.mimeApps = {
      enable = lib.mkDefault true;
      associations.added = mimeDefaults;
      defaultApplications = mimeDefaults;
    };
  };
in
{
  options.custom.desktop.addons.terminal = {
    enable = lib.mkEnableOption "terminal addon" // {
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
      description = "Inject terminal defaults into desktop Home Manager users.";
    };
  };

  config = lib.mkIf (config.custom.desktop.enable && cfg.enable && cfg.manageUserDefaults) {
    home-manager.users = lib.genAttrs desktopUsers (_username: {
      imports = [ userModule ];
    });
  };
}
