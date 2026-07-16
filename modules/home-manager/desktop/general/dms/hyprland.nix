# General Hyprland integration for DMS desktop sessions.
{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.desktop.hyprland;
  terminalCommand = config.home.sessionVariables.TERMINAL or "kitty";
  screenshotDirectory = "/tmp";
  dmsLauncher = pkgs.writeShellScriptBin "dms-run-with-wayland-input" ''
    unset GTK_IM_MODULE
    unset QT_IM_MODULE
    export QT_QPA_PLATFORM=wayland
    exec ${lib.getExe config.programs.dank-material-shell.package} run "$@"
  '';
  dmsCommand = "${dmsLauncher}/bin/dms-run-with-wayland-input";
  welinkClipboardBridge = pkgs.writeShellApplication {
    name = "welink-clipboard-bridge";
    runtimeInputs = with pkgs; [
      coreutils
      wl-clipboard
      xclip
    ];
    text = ''
      # Let WeLink process the non-consuming Ctrl+C binding first.
      sleep 0.2

      if clipboard_text="$(timeout 2 xclip -selection clipboard -out -target UTF8_STRING 2>/dev/null)"; then
        printf '%s' "$clipboard_text" | wl-copy --type 'text/plain;charset=utf-8'
      fi
    '';
  };
  dmsHyprlandConfig = "${inputs.dms}/core/internal/config/embedded";
  hyprlandLua =
    (builtins.replaceStrings
      [
        ''
          -- DMS_STARTUP_BEGIN
          hl.on("hyprland.start", function()
          	hl.exec_cmd("dbus-update-activation-environment --systemd --all")
          	hl.exec_cmd("systemctl --user start hyprland-session.target")
          end)
          -- DMS_STARTUP_END
        ''
        ''require("dms.binds-user")''
      ]
      [
        ''
          -- DMS_STARTUP_BEGIN
          hl.env("GLFW_IM_MODULE", "ibus")
          hl.env("DMS_SCREENSHOT_DIR", ${builtins.toJSON screenshotDirectory})
          hl.env("QT_IM_MODULE", "fcitx")
          hl.env("SDL_IM_MODULE", "fcitx")
          hl.env("TERMINAL", ${builtins.toJSON terminalCommand})
          hl.env("QT_QPA_PLATFORM", "wayland")
          hl.env("XCURSOR_SIZE", "24")
          hl.env("HYPRCURSOR_SIZE", "24")
          hl.env("XMODIFIERS", "@im=fcitx")

          hl.on("hyprland.start", function()
            hl.exec_cmd("uwsm finalize DMS_SCREENSHOT_DIR GLFW_IM_MODULE QT_IM_MODULE SDL_IM_MODULE TERMINAL QT_QPA_PLATFORM XMODIFIERS XCURSOR_SIZE HYPRCURSOR_SIZE")
            hl.exec_cmd("fcitx5 -d --replace")
            hl.exec_cmd(${builtins.toJSON dmsCommand})
          end)
          -- DMS_STARTUP_END
        ''
        "-- User keybind overrides are appended to dms.binds."
      ]
      (builtins.readFile "${dmsHyprlandConfig}/hyprland.lua")
    )
    + ''

      -- Keep applications launched by the DMS shell on the currently active workspace.
      hl.config({
        binds = {
          disable_keybind_grabbing = true,
        },
        input = {
          follow_mouse = 0,
        },
      	misc = {
      		initial_workspace_tracking = 0,
      	},
      	xwayland = {
      		force_zero_scaling = true,
      	},
      })

      -- Telegram uses its app id on Wayland and WM_CLASS on XWayland. Keep media
      -- previews floating with either backend while leaving the main window tiled.
      hl.window_rule({
        match = { class = "^(org\\.telegram\\.desktop|TelegramDesktop|telegram-desktop)$", title = "^(Media viewer|媒体查看器)$" },
        float = true,
        fullscreen = false,
        suppress_event = "fullscreen maximize fullscreenoutput",
        size = "1600 1000",
        center = true,
      })

      -- Keep every WeLink auxiliary window centered and floating, including
      -- views introduced by future client updates.
      hl.window_rule({
        match = { class = "^welink\\.exe$" },
        float = true,
        size = "1600 1000",
        center = true,
      })

      -- The main chat window shares the same XWayland class. This later,
      -- more-specific rule keeps only that window in the tiling layout.
      hl.window_rule({
        match = { class = "^welink\\.exe$", initial_title = "^WeLink$" },
        tile = true,
        suppress_event = "maximize",
      })

      -- WeLink starts its meeting helper even when only chat is used. Keep its
      -- otherwise-visible blank XWayland windows out of the active workspace.
      hl.window_rule({
        match = { class = "^hwwebniar\\.exe$" },
        workspace = "special:welink-helper silent",
        no_focus = true,
        no_initial_focus = true,
      })

      -- Wine exposes a tiny, untitled explorer.exe shell window for WeLink.
      -- Hide only that shell surface without affecting real Explorer windows.
      hl.window_rule({
        match = { class = "^explorer\\.exe$", initial_title = "^$" },
        workspace = "special:welink-helper silent",
        no_focus = true,
        no_initial_focus = true,
      })

      ${lib.optionalString cfg.welinkClipboardBridge.enable ''
        -- Let Ctrl+C reach WeLink, then copy its X11 text selection to Wayland.
        -- This deliberately does not handle context-menu or other mouse copies.
        hl.bind("CTRL + C", function()
          local active_window = hl.get_active_window()
          if active_window ~= nil and active_window.class == "welink.exe" then
            hl.dispatch(hl.dsp.exec_cmd(${builtins.toJSON "${welinkClipboardBridge}/bin/welink-clipboard-bridge"}))
          end
        end, { non_consuming = true, description = "Bridge WeLink clipboard to Wayland" })
      ''}
    '';
  hyprlandLuaFile = pkgs.writeText "dms-hyprland.lua" hyprlandLua;
  luaLiteral = value: builtins.toJSON value;
  renderMonitorRule =
    rule:
    let
      fields = lib.filterAttrs (_: value: value != null) rule;
      renderedFields = lib.mapAttrsToList (name: value: "${name} = ${luaLiteral value}") fields;
    in
    "hl.monitor({ ${lib.concatStringsSep ", " renderedFields} })";
  outputsLua =
    (builtins.readFile "${dmsHyprlandConfig}/hypr-outputs.lua")
    + lib.optionalString (cfg.outputRules != [ ]) ''

      -- Host-specific monitor rules
      ${lib.concatStringsSep "\n" (map renderMonitorRule cfg.outputRules)}
    '';
  outputsLuaFile = pkgs.writeText "dms-hypr-outputs.lua" outputsLua;
  dmsHyprlandFragments = {
    "binds.lua" = pkgs.writeText "dms-hypr-binds.lua" (
      (builtins.replaceStrings
        [
          "{{TERMINAL_COMMAND}}"
          ''hl.bind("SUPER + SHIFT + E", hl.dsp.exit())''
        ]
        [
          terminalCommand
          ''hl.bind("SUPER + SHIFT + E", hl.dsp.exec_cmd("uwsm stop"))''
        ]
        (builtins.readFile "${dmsHyprlandConfig}/hypr-binds.lua")
      )
      + "\n"
      + builtins.readFile ./hyprland-binds-user.lua
    );
    "colors.lua" = "${dmsHyprlandConfig}/hypr-colors.lua";
    "cursor.lua" = "${dmsHyprlandConfig}/hypr-cursor.lua";
    "layout.lua" = "${dmsHyprlandConfig}/hypr-layout.lua";
    "outputs.lua" = outputsLuaFile;
    "windowrules.lua" = "${dmsHyprlandConfig}/hypr-windowrules.lua";
  };
in
{
  options.custom.desktop.hyprland.outputRules = lib.mkOption {
    type = lib.types.listOf (
      lib.types.submodule {
        options = {
          output = lib.mkOption {
            type = lib.types.str;
            description = "Hyprland output name, for example DP-1.";
          };

          mode = lib.mkOption {
            type = lib.types.str;
            default = "preferred";
            description = "Hyprland monitor mode, for example preferred or 2560x1440@164.80.";
          };

          position = lib.mkOption {
            type = lib.types.str;
            default = "auto";
            description = "Hyprland monitor position, for example auto or 0x0.";
          };

          scale = lib.mkOption {
            type = lib.types.str;
            default = "auto";
            description = "Hyprland monitor scale, for example auto or 1.";
          };

          transform = lib.mkOption {
            type = lib.types.nullOr lib.types.int;
            default = null;
            description = "Hyprland monitor transform. Use 2 for an upside-down physical display.";
          };
        };
      }
    );
    default = [ ];
    description = "Host-specific Hyprland monitor rules appended after the DMS default monitor rule.";
  };

  config.home.sessionVariables.DMS_SCREENSHOT_DIR = screenshotDirectory;
  options.custom.desktop.hyprland.welinkClipboardBridge.enable =
    lib.mkEnableOption "WeLink Ctrl+C text clipboard bridge from XWayland to Wayland";

  config.home.activation.installDmsHyprlandConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
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
              ]
              || (name == "outputs.lua" && cfg.outputRules != [ ])
            then
              "1"
            else
              "0";
        in
        ''install_writable_fragment ${builtins.toJSON "${source}"} "$dms_dir/${name}" ${replaceExisting}''
      ) dmsHyprlandFragments
    )}

    # Reload Hyprland to pick up updated config fragments.
    if [ -d /tmp/hypr ]; then
      run hyprctl reload 2>/dev/null || true
    fi
  '';
}
