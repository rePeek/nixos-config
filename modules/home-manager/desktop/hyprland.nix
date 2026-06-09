{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  terminalCommand = config.home.sessionVariables.TERMINAL or "kitty";
  dmsLauncher = pkgs.writeShellScriptBin "dms-run-with-compose-input" ''
    export QT_IM_MODULE=compose
    exec ${lib.getExe config.programs.dank-material-shell.package} run "$@"
  '';
  dmsCommand = "${dmsLauncher}/bin/dms-run-with-compose-input";
  dmsHyprlandConfig = "${inputs.dms}/core/internal/config/embedded";
  hyprlandLua =
    builtins.replaceStrings
      [
        ''
          -- DMS_STARTUP_BEGIN
          hl.on("hyprland.start", function()
          	hl.exec_cmd("dbus-update-activation-environment --systemd --all")
          	hl.exec_cmd("systemctl --user start hyprland-session.target")
          end)
          -- DMS_STARTUP_END
        ''
      ]
      [
        ''
          -- DMS_STARTUP_BEGIN
          hl.env("GLFW_IM_MODULE", "ibus")
          hl.env("QT_IM_MODULE", "fcitx")
          hl.env("SDL_IM_MODULE", "fcitx")
          hl.env("TERMINAL", ${builtins.toJSON terminalCommand})
          hl.env("QT_QPA_PLATFORM", "wayland")
          hl.env("XCURSOR_SIZE", "24")
          hl.env("HYPRCURSOR_SIZE", "24")
          hl.env("XMODIFIERS", "@im=fcitx")

          hl.on("hyprland.start", function()
          	hl.exec_cmd("uwsm finalize GLFW_IM_MODULE QT_IM_MODULE SDL_IM_MODULE TERMINAL QT_QPA_PLATFORM XMODIFIERS XCURSOR_SIZE HYPRCURSOR_SIZE")
          	hl.exec_cmd("fcitx5 -d --replace")
          	hl.exec_cmd(${builtins.toJSON dmsCommand})
          end)
          -- DMS_STARTUP_END
        ''
      ]
      (builtins.readFile "${dmsHyprlandConfig}/hyprland.lua");
  hyprlandLuaFile = pkgs.writeText "dms-hyprland.lua" hyprlandLua;
  dmsHyprlandFragments = {
    "binds.lua" = pkgs.writeText "dms-hypr-binds.lua" (
      builtins.replaceStrings
        [
          "{{TERMINAL_COMMAND}}"
          ''hl.bind("SUPER + SHIFT + E", hl.dsp.exit())''
        ]
        [
          terminalCommand
          ''hl.bind("SUPER + SHIFT + E", hl.dsp.exec_cmd("uwsm stop"))''
        ]
        (builtins.readFile "${dmsHyprlandConfig}/hypr-binds.lua")
    );
    "binds-user.lua" = ./hyprland-binds-user.lua;
    "colors.lua" = "${dmsHyprlandConfig}/hypr-colors.lua";
    "cursor.lua" = "${dmsHyprlandConfig}/hypr-cursor.lua";
    "layout.lua" = "${dmsHyprlandConfig}/hypr-layout.lua";
    "outputs.lua" = "${dmsHyprlandConfig}/hypr-outputs.lua";
    "windowrules.lua" = "${dmsHyprlandConfig}/hypr-windowrules.lua";
  };
in
{
  home.activation.installDmsHyprlandConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    hypr_dir="${config.xdg.configHome}/hypr"
    dms_dir="$hypr_dir/dms"
    run mkdir -p "$dms_dir"

    hypr_lua="$hypr_dir/hyprland.lua"
    if [ -L "$hypr_lua" ]; then
      run rm "$hypr_lua"
    fi
    run cp ${builtins.toJSON "${hyprlandLuaFile}"} "$hypr_lua"
    run chmod u+w "$hypr_lua"

    install_writable_fragment() {
      local source="$1"
      local target="$2"
      local replace_existing="$3"

      if [ -L "$target" ]; then
        local link_target
        link_target="$(readlink "$target")"
        if [[ "$link_target" == /nix/store/* ]]; then
          run rm "$target"
        else
          return
        fi
      fi

      if [ "$replace_existing" = 1 ] || [ ! -e "$target" ]; then
        run cp "$source" "$target"
        run chmod u+w "$target"
      elif [ -f "$target" ] && [ ! -w "$target" ]; then
        run chmod u+w "$target"
      fi
    }

    ${lib.concatStringsSep "\n" (
      lib.mapAttrsToList (
        name: source:
        let
          replaceExisting =
            if
              lib.elem name [
                "binds.lua"
                "binds-user.lua"
              ]
            then
              "1"
            else
              "0";
        in
        ''install_writable_fragment ${builtins.toJSON "${source}"} "$dms_dir/${name}" ${replaceExisting}''
      ) dmsHyprlandFragments
    )}
  '';
}
