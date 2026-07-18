{
  config,
  lib,
  pkgs,
  ...
}:
let
  stylixColors = lib.attrByPath [ "lib" "stylix" "colors" "withHashtag" ] null config;
  stylixThemeEnabled = stylixColors != null;
in
{
  home.shellAliases = {
    zs = "zellij -s";
    za = "zellij a";
    zz = "zellij attach --create main";
    zj = "zellij -l maximized";
  };

  programs.zellij = {
    enable = true;
    package = pkgs.zellij;
    settings =
      lib.optionalAttrs stylixThemeEnabled {
        theme = "stylix";
      }
      // {
        pane_frames = true;
        ui.pane_frames.rounded_corners = true;
        simplified_ui = true;
        default_layout = "maximized";
        # misc
        default_shell = "fish";
        # keybind
        keybinds =
          with builtins;
          let
            binder =
              bind:
              let
                keys = elemAt bind 0;
                action = elemAt bind 1;
                argKeys = map (k: "\"${k}\"") (lib.lists.flatten [ keys ]);
              in
              {
                name = "bind ${concatStringsSep " " argKeys}";
                value = action;
              };
            layer = binds: (listToAttrs (map binder binds));
          in
          {
            locked = layer [
              [
                [ "Alt f" ]
                { LaunchPlugin = "filepicker"; }
              ]
            ];
          };
      };

    layouts.maximized = ''
      layout {
        pane
      }
    '';
  };
}
