{
  lib,
  ...
}:
{
  home.shellAliases = {
    zs = "zellij -s";
    za = "zellij a";
    zz = "zellij attach --create main";
    zj = "zellij -l welcome";
  };

  programs.zellij = {
    enable = true;
    settings = {
      # ui
      theme = "catppuccin-mocha";
      ui.pane_frames.rounded_corners = true;
      simplified_ui = true;
      default_layout = "compact";
      # misc
      default_shell = "nu";
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
