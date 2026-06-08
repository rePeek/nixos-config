{
  config,
  inputs,
  pkgs,
  ...
}:
let
  terminalCommand = config.home.sessionVariables.TERMINAL or "kitty";
  dmsHyprlandConfig = "${inputs.dms}/core/internal/config/embedded";
  startDmsSession = pkgs.writeShellScript "start-dms-session" ''
    sleep 1
    systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP XDG_SESSION_TYPE HYPRLAND_INSTANCE_SIGNATURE QT_QPA_PLATFORM
    dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP XDG_SESSION_TYPE HYPRLAND_INSTANCE_SIGNATURE QT_QPA_PLATFORM
    systemctl --user reset-failed dms.service
    systemctl --user start dms.service
  '';
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
          	hl.exec_cmd("dbus-update-activation-environment --systemd --all")
          	hl.exec_cmd("fcitx5 -d --replace")
          	hl.exec_cmd(${builtins.toJSON "${startDmsSession}"})
          	hl.exec_cmd("systemctl --user start hyprland-session.target")
          end)
          -- DMS_STARTUP_END
        ''
      ]
      (builtins.readFile "${dmsHyprlandConfig}/hyprland.lua");
in
{
  xdg.configFile = {
    "hypr/hyprland.lua".text = hyprlandLua;
    "hypr/dms/binds.lua".text = builtins.replaceStrings [ "{{TERMINAL_COMMAND}}" ] [ terminalCommand ] (
      builtins.readFile "${dmsHyprlandConfig}/hypr-binds.lua"
    );
    "hypr/dms/binds-user.lua".text = builtins.readFile ./hyprland-binds-user.lua;
    "hypr/dms/colors.lua".source = "${dmsHyprlandConfig}/hypr-colors.lua";
    "hypr/dms/cursor.lua".source = "${dmsHyprlandConfig}/hypr-cursor.lua";
    "hypr/dms/layout.lua".source = "${dmsHyprlandConfig}/hypr-layout.lua";
    "hypr/dms/outputs.lua".source = "${dmsHyprlandConfig}/hypr-outputs.lua";
    "hypr/dms/windowrules.lua".source = "${dmsHyprlandConfig}/hypr-windowrules.lua";
  };
}
