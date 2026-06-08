# File manager addon with matching directory defaults.
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.custom.desktop.addons.files;
  desktopUsers = config.custom.desktop.users;

  mimeDefaults = {
    "inode/directory" = [ cfg.desktopFile ];
  };

  userModule = {
    home.packages = with pkgs; [
      nemo
    ];

    dconf.settings = {
      "org/nemo/preferences" = {
        always-use-browser = true;
        close-device-view-on-device-eject = true;
        date-font-choice = "auto-mono";
        date-format = "iso";
        last-server-connect-method = 3;
        quick-renames-with-pause-in-between = true;
        show-edit-icon-toolbar = false;
        show-full-path-titles = false;
        show-hidden-files = true;
        show-home-icon-toolbar = true;
        show-new-folder-icon-toolbar = true;
        show-open-in-terminal-toolbar = false;
        show-search-icon-toolbar = false;
        show-show-thumbnails-toolbar = false;
        thumbnail-limit = 10485760;
      };
      "org/nemo/preferences/menu-config" = {
        background-menu-open-as-root = false;
        selection-menu-open-as-root = false;
        selection-menu-open-in-terminal = false;
        selection-menu-scripts = false;
      };
      "org/nemo/search" = {
        search-reverse-sort = false;
        search-sort-column = "name";
      };
      "org/nemo/window-state" = {
        maximized = true;
        network-expanded = true;
        side-pane-view = "places";
        sidebar-bookmark-breakpoint = 2;
        sidebar-width = 220;
        start-with-sidebar = true;
      };
    };

    xdg.configFile."mimeapps.list".force = lib.mkDefault true;
    xdg.mimeApps = {
      enable = lib.mkDefault true;
      associations.added = mimeDefaults;
      defaultApplications = mimeDefaults;
    };
  };
in
{
  options.custom.desktop.addons.files = {
    enable = lib.mkEnableOption "file manager addon" // {
      default = true;
    };

    desktopFile = lib.mkOption {
      type = lib.types.str;
      default = "nemo.desktop";
      description = "Desktop file used for directory MIME associations.";
    };

    manageUserDefaults = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Inject file manager defaults into desktop Home Manager users.";
    };
  };

  config = lib.mkIf (config.custom.desktop.enable && cfg.enable && cfg.manageUserDefaults) {
    home-manager.users = lib.genAttrs desktopUsers (_username: {
      imports = [ userModule ];
    });
  };
}
