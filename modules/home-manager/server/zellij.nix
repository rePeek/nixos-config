{
  lib,
  pkgs,
  ...
}:
{
  home.shellAliases = {
    zs = "zellij -s";
    za = "zellij a";
    zz = "zellij attach --create main";
    zj = "zellij attach --create $(basename $PWD)";
  };

  programs.zellij = {
    enable = true;
    package = pkgs.zellij;
    settings = {
      support_kitty_keyboard_protocol = false;
      pane_frames = true;
      pane_frame_style = "full";
      stacked_pane_list = false;
      ui.pane_frames.rounded_corners = true;
      simplified_ui = true;
      default_layout = "compact";
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

  };
}
