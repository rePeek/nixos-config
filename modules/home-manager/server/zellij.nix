{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  stylixColors = lib.attrByPath [ "lib" "stylix" "colors" "withHashtag" ] null config;
  stylixThemeEnabled = stylixColors != null;
  colors =
    if stylixThemeEnabled then
      stylixColors
    else
      {
        base00 = "#181825";
        base01 = "#313244";
        base03 = "#6c7086";
        base05 = "#cdd6f4";
      };
  zjstatusPackage = inputs.zjstatus.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  home.shellAliases = {
    zs = "zellij -s";
    za = "zellij a";
    zz = "zellij attach --create main";
    zj = "zellij -l zjstatus";
  };

  programs.zellij = {
    enable = true;
    package = pkgs.zellij;
    settings =
      lib.optionalAttrs stylixThemeEnabled {
        theme = "stylix";
      }
      // {
        pane_frames = false;
        ui.pane_frames.rounded_corners = true;
        simplified_ui = true;
        default_layout = "zjstatus";
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

    layouts.zjstatus = ''
      layout {
        default_tab_template {
          children
          pane size=1 borderless=true {
            plugin location="file:${zjstatusPackage}/bin/zjstatus.wasm" {
              format_left  "{mode}#[fg=${colors.base05},bg=${colors.base00}] {session} "
              format_center "{tabs}"
              format_right "{datetime}"
              format_space "#[bg=${colors.base00}]"

              border_enabled "false"
              hide_frame_for_single_pane "false"

              mode_normal "#[fg=${colors.base05},bg=${colors.base01},bold] {name} "
              mode_locked "#[fg=${colors.base03},bg=${colors.base00}] {name} "
              mode_resize "#[fg=${colors.base05},bg=${colors.base01},bold] {name} "
              mode_pane "#[fg=${colors.base05},bg=${colors.base01},bold] {name} "
              mode_tab "#[fg=${colors.base05},bg=${colors.base01},bold] {name} "
              mode_scroll "#[fg=${colors.base05},bg=${colors.base01},bold] {name} "
              mode_tmux "#[fg=${colors.base05},bg=${colors.base01},bold] {name} "
              mode_default_to_mode "normal"

              tab_normal "#[fg=${colors.base03},bg=${colors.base00}] {index}:{name} {sync_indicator}{fullscreen_indicator}{floating_indicator}"
              tab_active "#[fg=${colors.base05},bg=${colors.base01},bold] {index}:{name} {sync_indicator}{fullscreen_indicator}{floating_indicator}"
              tab_sync_indicator "S "
              tab_fullscreen_indicator "F "
              tab_floating_indicator "P "

              datetime "#[fg=${colors.base03},bg=${colors.base00}] {format} "
              datetime_format "%Y-%m-%d %H:%M"
            }
          }
        }
      }
    '';
  };
}
