{
  inputs,
  pkgs,
  terminalCommand,
  startDmsSession,
  ...
}:
let
  dmsHyprlandConfig = "${inputs.dms}/core/internal/config/embedded";

  sessionPackage =
    (pkgs.writeTextDir "share/wayland-sessions/hyprland-dms.desktop" ''
      [Desktop Entry]
      Name=Hyprland DMS
      Comment=Hyprland session using DankMaterialShell configuration
      Exec=Hyprland --config ''${HOME}/.config/hypr/hyprland.conf
      Type=Application
      DesktopNames=Hyprland
    '').overrideAttrs
      (_: {
        passthru.providedSessions = [ "hyprland-dms" ];
      });

  xdgConfigFile = {
    "hypr/hyprland.conf" = {
      force = true;
      text = ''
        # Managed by Home Manager from the NixOS desktop profile.

        exec-once = dbus-update-activation-environment --systemd --all
        exec-once = fcitx5 -d --replace
        exec-once = ${startDmsSession}

        env = GLFW_IM_MODULE,ibus
        env = QT_IM_MODULE,fcitx
        env = SDL_IM_MODULE,fcitx
        env = TERMINAL,${terminalCommand}
        env = QT_QPA_PLATFORM,wayland
        env = XCURSOR_SIZE,24
        env = HYPRCURSOR_SIZE,24
        env = XMODIFIERS,@im=fcitx

        monitor = ,preferred,auto,auto

        input {
          kb_layout = us
          numlock_by_default = true

          touchpad {
            tap-to-click = true
            natural_scroll = true
          }
        }

        general {
          gaps_in = 5
          gaps_out = 5
          border_size = 2
          layout = dwindle
        }

        decoration {
          rounding = 12
        }

        misc {
          disable_hyprland_logo = true
          disable_splash_rendering = true
        }

        dwindle {
          preserve_split = true
        }
      '';
    };
    "hypr/hyprland.lua".text = builtins.readFile "${dmsHyprlandConfig}/hyprland.lua";
    "hypr/dms/binds.lua".text = builtins.replaceStrings [ "{{TERMINAL_COMMAND}}" ] [ terminalCommand ] (
      builtins.readFile "${dmsHyprlandConfig}/hypr-binds.lua"
    );
    "hypr/dms/binds-user.lua".text = builtins.readFile "${dmsHyprlandConfig}/hypr-binds-user.lua";
    "hypr/dms/colors.lua".source = "${dmsHyprlandConfig}/hypr-colors.lua";
    "hypr/dms/cursor.lua".source = "${dmsHyprlandConfig}/hypr-cursor.lua";
    "hypr/dms/layout.lua".source = "${dmsHyprlandConfig}/hypr-layout.lua";
    "hypr/dms/outputs.lua".source = "${dmsHyprlandConfig}/hypr-outputs.lua";
    "hypr/dms/windowrules.lua".source = "${dmsHyprlandConfig}/hypr-windowrules.lua";
  };
in
{
  inherit sessionPackage xdgConfigFile;
}
