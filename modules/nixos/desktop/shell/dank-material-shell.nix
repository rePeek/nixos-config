{
  config,
  inputs,
  lib,
  pkgs,
  pkgsUnstable,
  ...
}:
let
  cfg = config.custom.desktop.shell;
  defaults = import ./defaults.nix {
    inherit pkgs pkgsUnstable;
  };

  dmsEnabled =
    config.custom.service.desktop.enable && cfg.enable && cfg.backend == "dank-material-shell";

  desktopUsers = config.custom.desktop.users;
  dmsHyprlandConfig = "${inputs.dms}/core/internal/config/embedded";
  startDmsSession = pkgs.writeShellScript "start-dms-session" ''
    sleep 1
    systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP XDG_SESSION_TYPE HYPRLAND_INSTANCE_SIGNATURE QT_QPA_PLATFORM
    dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP XDG_SESSION_TYPE HYPRLAND_INSTANCE_SIGNATURE QT_QPA_PLATFORM
    systemctl --user reset-failed dms.service
    systemctl --user start dms.service
  '';
  quickshellPackage = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;
  legacyHyprlandBinds = ''
    bind = SUPER, Q, killactive
    bind = SUPER, F, fullscreen, 0
    bind = SUPER SHIFT, F, fullscreen, 1
    bind = SUPER, Space, exec, hyprctl dispatch togglefloating && hyprctl dispatch resizeactive exact 1111 700 && hyprctl dispatch centerwindow
    bind = SUPER, Escape, exec, dms ipc call lock lock
    bind = ALT, Escape, exec, dms ipc call lock lock
    bind = SUPER, P, pseudo
    bind = SUPER, X, togglesplit
    bind = SUPER, T, exec, dms ipc theme toggle
    bind = SUPER SHIFT, Escape, exec, dms ipc powermenu toggle
    bind = SUPER SHIFT, B, exec, dms ipc bar toggle
    bind = SUPER, C, exec, dms ipc color-picker toggle
    bind = SUPER, W, exec, dms ipc wallpaper next
    bind = SUPER SHIFT, W, exec, dms ipc wallpaper prev
    bind = SUPER, N, exec, dms ipc notifications toggle
    bind = CTRL SHIFT, Escape, exec, hyprctl dispatch exec '[workspace 11] resources'
    bind = SUPER, F1, exec, dms ipc keybinds toggle
    bind = SUPER, Return, exec, kitty
    bind = ALT, Return, exec, [float; size 1111 700] kitty
    bind = SUPER SHIFT, Return, exec, [fullscreen] kitty
    bind = SUPER SHIFT, E, exec, hyprctl dispatch exec '[float; size 1111 700] kitty -e yazi'
    bind = SUPER, B, exec, hyprctl dispatch exec '[workspace 1 silent] firefox'
    bind = SUPER, D, exec, dms ipc launcher toggle
    bind = SUPER SHIFT, S, exec, dms screenshot
    bind = CTRL SHIFT, S, exec, dms screenshot
    bind = SUPER SHIFT, Print, exec, dms screenshot window

    bind = SUPER, left, movefocus, l
    bind = SUPER, right, movefocus, r
    bind = SUPER, up, movefocus, u
    bind = SUPER, down, movefocus, d
    bind = SUPER, h, movefocus, l
    bind = SUPER, j, movefocus, d
    bind = SUPER, k, movefocus, u
    bind = SUPER, l, movefocus, r

    bind = SUPER, 1, workspace, 1
    bind = SUPER, 2, workspace, 2
    bind = SUPER, 3, workspace, 3
    bind = SUPER, 4, workspace, 4
    bind = SUPER, 5, workspace, 5
    bind = SUPER, 6, workspace, 6
    bind = SUPER, 7, workspace, 7
    bind = SUPER, 8, workspace, 8
    bind = SUPER, 9, workspace, 9
    bind = SUPER, 0, workspace, 10

    bind = SUPER SHIFT, 1, movetoworkspacesilent, 1
    bind = SUPER SHIFT, 2, movetoworkspacesilent, 2
    bind = SUPER SHIFT, 3, movetoworkspacesilent, 3
    bind = SUPER SHIFT, 4, movetoworkspacesilent, 4
    bind = SUPER SHIFT, 5, movetoworkspacesilent, 5
    bind = SUPER SHIFT, 6, movetoworkspacesilent, 6
    bind = SUPER SHIFT, 7, movetoworkspacesilent, 7
    bind = SUPER SHIFT, 8, movetoworkspacesilent, 8
    bind = SUPER SHIFT, 9, movetoworkspacesilent, 9
    bind = SUPER SHIFT, 0, movetoworkspacesilent, 10
    bind = SUPER CTRL, c, movetoworkspace, empty

    bind = SUPER SHIFT, left, movewindow, l
    bind = SUPER SHIFT, right, movewindow, r
    bind = SUPER SHIFT, up, movewindow, u
    bind = SUPER SHIFT, down, movewindow, d
    bind = SUPER SHIFT, h, movewindow, l
    bind = SUPER SHIFT, j, movewindow, d
    bind = SUPER SHIFT, k, movewindow, u
    bind = SUPER SHIFT, l, movewindow, r

    bind = SUPER CTRL, left, resizeactive, -80 0
    bind = SUPER CTRL, right, resizeactive, 80 0
    bind = SUPER CTRL, up, resizeactive, 0 -80
    bind = SUPER CTRL, down, resizeactive, 0 80
    bind = SUPER CTRL, h, resizeactive, -80 0
    bind = SUPER CTRL, j, resizeactive, 0 80
    bind = SUPER CTRL, k, resizeactive, 0 -80
    bind = SUPER CTRL, l, resizeactive, 80 0

    bind = SUPER ALT, left, moveactive, -80 0
    bind = SUPER ALT, right, moveactive, 80 0
    bind = SUPER ALT, up, moveactive, 0 -80
    bind = SUPER ALT, down, moveactive, 0 80
    bind = SUPER ALT, h, moveactive, -80 0
    bind = SUPER ALT, j, moveactive, 0 80
    bind = SUPER ALT, k, moveactive, 0 -80
    bind = SUPER ALT, l, moveactive, 80 0

    bind = SUPER, mouse_down, workspace, e-1
    bind = SUPER, mouse_up, workspace, e+1
    bind = SUPER, V, exec, dms ipc clipboard toggle

    bind = , XF86AudioMute, exec, dms ipc call audio mute
    bindl = , XF86MonBrightnessUp, exec, dms ipc call brightness increment 5 ""
    bindl = , XF86MonBrightnessDown, exec, dms ipc call brightness decrement 5 ""
    bindl = SUPER, XF86MonBrightnessUp, exec, dms ipc call brightness set 100 ""
    bindl = SUPER, XF86MonBrightnessDown, exec, dms ipc call brightness set 1 ""
    bindle = , XF86AudioRaiseVolume, exec, dms ipc call audio increment 2
    bindle = , XF86AudioLowerVolume, exec, dms ipc call audio decrement 2
    bindle = SUPER, f11, exec, dms ipc call audio increment 2
    bindle = SUPER, f12, exec, dms ipc call audio decrement 2
    bindm = SUPER, mouse:272, movewindow
    bindm = SUPER, mouse:273, resizewindow
  '';
  legacyHyprlandBindsLua = ''
    -- System desktop profile compatibility layer for the previous Hyprland binds.
    hl.bind("SUPER + Q", hl.dsp.window.close())
    hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
    hl.bind("SUPER + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
    hl.bind("SUPER + Space", hl.dsp.exec_cmd("hyprctl dispatch togglefloating && hyprctl dispatch resizeactive exact 1111 700 && hyprctl dispatch centerwindow"))
    hl.bind("SUPER + Escape", hl.dsp.exec_cmd("dms ipc call lock lock"))
    hl.bind("ALT + Escape", hl.dsp.exec_cmd("dms ipc call lock lock"))
    hl.bind("SUPER + P", hl.dsp.layout("pseudo"))
    hl.bind("SUPER + X", hl.dsp.layout("togglesplit"))
    hl.bind("SUPER + T", hl.dsp.exec_cmd("dms ipc theme toggle"))
    hl.bind("SUPER + SHIFT + Escape", hl.dsp.exec_cmd("dms ipc powermenu toggle"))
    hl.bind("SUPER + SHIFT + B", hl.dsp.exec_cmd("dms ipc bar toggle"))
    hl.bind("SUPER + C", hl.dsp.exec_cmd("dms ipc color-picker toggle"))
    hl.bind("SUPER + W", hl.dsp.exec_cmd("dms ipc wallpaper next"))
    hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd("dms ipc wallpaper prev"))
    hl.bind("SUPER + N", hl.dsp.exec_cmd("dms ipc notifications toggle"))
    hl.bind("CTRL + SHIFT + Escape", hl.dsp.exec_cmd([[hyprctl dispatch exec '[workspace 11] resources']]))
    hl.bind("SUPER + F1", hl.dsp.exec_cmd("dms ipc keybinds toggle"))
    hl.bind("SUPER + Return", hl.dsp.exec_cmd("kitty"))
    hl.bind("ALT + Return", hl.dsp.exec_cmd("[float; size 1111 700] kitty"))
    hl.bind("SUPER + SHIFT + Return", hl.dsp.exec_cmd("[fullscreen] kitty"))
    hl.bind("SUPER + SHIFT + E", hl.dsp.exec_cmd([[hyprctl dispatch exec '[float; size 1111 700] kitty -e yazi']]))
    hl.bind("SUPER + B", hl.dsp.exec_cmd([[hyprctl dispatch exec '[workspace 1 silent] firefox']]))
    hl.bind("SUPER + D", hl.dsp.exec_cmd("dms ipc launcher toggle"))
    hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("dms screenshot"))
    hl.bind("CTRL + SHIFT + S", hl.dsp.exec_cmd("dms screenshot"))
    hl.bind("SUPER + SHIFT + Print", hl.dsp.exec_cmd("dms screenshot window"))

    hl.bind("SUPER + 0", hl.dsp.focus({ workspace = "10" }))
    hl.bind("SUPER + SHIFT + 1", hl.dsp.exec_cmd("hyprctl dispatch movetoworkspacesilent 1"))
    hl.bind("SUPER + SHIFT + 2", hl.dsp.exec_cmd("hyprctl dispatch movetoworkspacesilent 2"))
    hl.bind("SUPER + SHIFT + 3", hl.dsp.exec_cmd("hyprctl dispatch movetoworkspacesilent 3"))
    hl.bind("SUPER + SHIFT + 4", hl.dsp.exec_cmd("hyprctl dispatch movetoworkspacesilent 4"))
    hl.bind("SUPER + SHIFT + 5", hl.dsp.exec_cmd("hyprctl dispatch movetoworkspacesilent 5"))
    hl.bind("SUPER + SHIFT + 6", hl.dsp.exec_cmd("hyprctl dispatch movetoworkspacesilent 6"))
    hl.bind("SUPER + SHIFT + 7", hl.dsp.exec_cmd("hyprctl dispatch movetoworkspacesilent 7"))
    hl.bind("SUPER + SHIFT + 8", hl.dsp.exec_cmd("hyprctl dispatch movetoworkspacesilent 8"))
    hl.bind("SUPER + SHIFT + 9", hl.dsp.exec_cmd("hyprctl dispatch movetoworkspacesilent 9"))
    hl.bind("SUPER + SHIFT + 0", hl.dsp.exec_cmd("hyprctl dispatch movetoworkspacesilent 10"))
    hl.bind("SUPER + CTRL + c", hl.dsp.exec_cmd("hyprctl dispatch movetoworkspace empty"))

    hl.bind("SUPER + CTRL + left", hl.dsp.exec_cmd("hyprctl dispatch resizeactive -80 0"))
    hl.bind("SUPER + CTRL + right", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 80 0"))
    hl.bind("SUPER + CTRL + up", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 -80"))
    hl.bind("SUPER + CTRL + down", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 80"))
    hl.bind("SUPER + CTRL + H", hl.dsp.exec_cmd("hyprctl dispatch resizeactive -80 0"))
    hl.bind("SUPER + CTRL + J", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 80"))
    hl.bind("SUPER + CTRL + K", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 -80"))
    hl.bind("SUPER + CTRL + L", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 80 0"))

    hl.bind("SUPER + ALT + left", hl.dsp.exec_cmd("hyprctl dispatch moveactive -80 0"))
    hl.bind("SUPER + ALT + right", hl.dsp.exec_cmd("hyprctl dispatch moveactive 80 0"))
    hl.bind("SUPER + ALT + up", hl.dsp.exec_cmd("hyprctl dispatch moveactive 0 -80"))
    hl.bind("SUPER + ALT + down", hl.dsp.exec_cmd("hyprctl dispatch moveactive 0 80"))
    hl.bind("SUPER + ALT + H", hl.dsp.exec_cmd("hyprctl dispatch moveactive -80 0"))
    hl.bind("SUPER + ALT + J", hl.dsp.exec_cmd("hyprctl dispatch moveactive 0 80"))
    hl.bind("SUPER + ALT + K", hl.dsp.exec_cmd("hyprctl dispatch moveactive 0 -80"))
    hl.bind("SUPER + ALT + L", hl.dsp.exec_cmd("hyprctl dispatch moveactive 80 0"))

    hl.bind("SUPER + V", hl.dsp.exec_cmd("dms ipc clipboard toggle"))
    hl.bind("XF86AudioMute", hl.dsp.exec_cmd("dms ipc call audio mute"), { locked = true })
    hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd([[dms ipc call brightness increment 5 ""]]), { locked = true, repeating = true })
    hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd([[dms ipc call brightness decrement 5 ""]]), { locked = true, repeating = true })
    hl.bind("SUPER + XF86MonBrightnessUp", hl.dsp.exec_cmd([[dms ipc call brightness set 100 ""]]), { locked = true })
    hl.bind("SUPER + XF86MonBrightnessDown", hl.dsp.exec_cmd([[dms ipc call brightness set 1 ""]]), { locked = true })
    hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("dms ipc call audio increment 2"), { locked = true, repeating = true })
    hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("dms ipc call audio decrement 2"), { locked = true, repeating = true })
    hl.bind("SUPER + f11", hl.dsp.exec_cmd("dms ipc call audio increment 2"), { locked = true, repeating = true })
    hl.bind("SUPER + f12", hl.dsp.exec_cmd("dms ipc call audio decrement 2"), { locked = true, repeating = true })
  '';
  hyprlandDmsSession =
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

  userDesktopModule =
    username:
    let
      user = config.users.users.${username} or { };
      homeDirectory = user.home or "/home/${username}";
    in
    { config, lib, ... }:
    {
      imports = [
        inputs.dms.homeModules.dank-material-shell
      ];

      home = {
        username = lib.mkDefault username;
        homeDirectory = lib.mkDefault homeDirectory;
        stateVersion = lib.mkDefault "25.11";
        packages = defaults.homePackages;
        pointerCursor = lib.mkDefault defaults.gtk.cursorTheme;
      };

      programs.home-manager.enable = lib.mkDefault true;

      programs.firefox.enable = lib.mkDefault true;

      programs.dank-material-shell = {
        enable = lib.mkDefault true;
        dgop.package = lib.mkDefault pkgsUnstable.dgop;
        quickshell.package = lib.mkDefault quickshellPackage;
        systemd.enable = lib.mkDefault false;
        settings = lib.mkDefault defaults.settings;
        clipboardSettings = lib.mkDefault defaults.clipboardSettings;
      };

      gtk = {
        enable = lib.mkDefault true;
        font = lib.mkDefault defaults.gtk.font;
        theme = lib.mkDefault defaults.gtk.theme;
        iconTheme = lib.mkDefault defaults.gtk.iconTheme;
        cursorTheme = lib.mkDefault defaults.gtk.cursorTheme;
      };

      dconf.settings = defaults.dconfSettings;

      home.sessionVariables = {
        TERMINAL = lib.mkDefault "kitty";
      };

      home.activation.migrateDmsSessionState = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
        sessionFile="${config.xdg.stateHome}/DankMaterialShell/session.json"

        if [ -L "$sessionFile" ]; then
          target="$(readlink "$sessionFile")"
          if [[ "$target" == /nix/store/* ]]; then
            run rm "$sessionFile"
            if [ -f "$sessionFile.bkp" ]; then
              run cp "$sessionFile.bkp" "$sessionFile"
            fi
          fi
        fi
      '';

      xdg.configFile = {
        "xdg-terminals.list".text = lib.mkDefault ''
          kitty.desktop
        '';

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
            env = TERMINAL,kitty
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

            ${legacyHyprlandBinds}
          '';
        };
        "hypr/hyprland.lua".text = builtins.readFile "${dmsHyprlandConfig}/hyprland.lua";
        "hypr/dms/binds.lua".text = builtins.replaceStrings [ "{{TERMINAL_COMMAND}}" ] [ "kitty" ] (
          builtins.readFile "${dmsHyprlandConfig}/hypr-binds.lua"
        );
        "hypr/dms/binds-user.lua".text = legacyHyprlandBindsLua;
        "hypr/dms/colors.lua".source = "${dmsHyprlandConfig}/hypr-colors.lua";
        "hypr/dms/cursor.lua".source = "${dmsHyprlandConfig}/hypr-cursor.lua";
        "hypr/dms/layout.lua".source = "${dmsHyprlandConfig}/hypr-layout.lua";
        "hypr/dms/outputs.lua".source = "${dmsHyprlandConfig}/hypr-outputs.lua";
        "hypr/dms/windowrules.lua".source = "${dmsHyprlandConfig}/hypr-windowrules.lua";
      };
    };
in
{
  imports = [
    inputs.dms.nixosModules.dank-material-shell
  ];

  config = lib.mkIf dmsEnabled {
    assertions = [
      {
        assertion = cfg.compositor == "hyprland";
        message = "custom.desktop.shell.compositor currently only supports hyprland.";
      }
    ];

    programs.dank-material-shell = {
      enable = true;
      dgop.package = pkgsUnstable.dgop;
      systemd.enable = true;
      quickshell.package = quickshellPackage;
    };

    systemd.user.services.dms = {
      environment.QT_QPA_PLATFORM = "wayland";
      serviceConfig = {
        ExecStart = lib.mkForce "${config.programs.dank-material-shell.package}/bin/dms run";
        UnsetEnvironment = [
          "QT_IM_MODULE"
          "QT_PLUGIN_PATH"
          "QML2_IMPORT_PATH"
        ];
      };
      path = [
        quickshellPackage
      ];
    };

    services.displayManager.sessionPackages = [
      hyprlandDmsSession
    ];
    services.displayManager.defaultSession = "hyprland-dms";

    home-manager.users = lib.mkIf cfg.manageUserDefaults (
      lib.genAttrs desktopUsers (username: {
        imports = [
          (userDesktopModule username)
        ];
      })
    );
  };
}
