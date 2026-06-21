# Wallpaper collection and DMS session defaults for desktop users.
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.custom.desktop.defaults.wallpaper;
  wallpaperFiles = if cfg.directory == null then { } else builtins.readDir cfg.directory;
  imageExtensions = [
    ".avif"
    ".bmp"
    ".exr"
    ".gif"
    ".heif"
    ".jpeg"
    ".jpg"
    ".jxl"
    ".png"
    ".webp"
  ];
  isWallpaperImage =
    name: type:
    type == "regular"
    && lib.any (extension: lib.hasSuffix extension (lib.toLower name)) imageExtensions;
  wallpaperNames = lib.filter (name: isWallpaperImage name wallpaperFiles.${name}) (
    lib.attrNames wallpaperFiles
  );
  wallpaperFileSources = lib.listToAttrs (
    map (name: {
      name = "${cfg.collectionDirectory}/${name}";
      value.source = cfg.directory + "/${name}";
    }) wallpaperNames
  );

  wallpaperDirectory = "${config.home.homeDirectory}/${cfg.collectionDirectory}";
  sessionFile = "${config.xdg.stateHome}/DankMaterialShell/session.json";
in
{
  options.custom.desktop.defaults.wallpaper = {
    enable = lib.mkEnableOption "desktop wallpaper defaults";

    directory = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Directory containing wallpaper images for this user.";
      example = lib.literalExpression "../../assets/wallpapers";
    };

    initialStrategy = lib.mkOption {
      type = lib.types.enum [
        "none"
        "first"
        "random"
        "fixed"
      ];
      default = "first";
      description = "Strategy used to choose the initial DMS session wallpaper from the wallpaper directory.";
    };

    fixedFile = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Wallpaper file name used when strategy is fixed.";
    };

    manageHomeCollection = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Link wallpaper images into this user's wallpaper collection.";
    };

    setDmsSession = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Set the DMS session wallpaper during Home Manager activation.";
    };

    collectionDirectory = lib.mkOption {
      type = lib.types.str;
      default = "Pictures/wallpapers/nixos";
      description = "Home-relative directory used for wallpaper collection links.";
    };
  };

  config = lib.mkIf (config.custom.desktop.enable && cfg.enable) {
    assertions = [
      {
        assertion = cfg.directory != null;
        message = "custom.desktop.defaults.wallpaper.directory must be set when wallpaper defaults are enabled.";
      }
      {
        assertion = wallpaperNames != [ ] || cfg.initialStrategy == "none";
        message = "custom.desktop.defaults.wallpaper.directory does not contain any supported wallpaper image.";
      }
      {
        assertion =
          cfg.initialStrategy != "fixed" || (cfg.fixedFile != null && lib.elem cfg.fixedFile wallpaperNames);
        message = "custom.desktop.defaults.wallpaper.fixedFile must name an image in the wallpaper directory.";
      }
    ];

    home.file = lib.mkIf cfg.manageHomeCollection wallpaperFileSources;

    home.activation.configureDmsWallpaper = lib.mkIf cfg.setDmsSession (
      lib.hm.dag.entryAfter [ "linkGeneration" ] ''
        session_file=${lib.escapeShellArg sessionFile}
        wallpaper_dir=${lib.escapeShellArg wallpaperDirectory}
        initial_strategy=${lib.escapeShellArg cfg.initialStrategy}
        fixed_file=${lib.escapeShellArg (if cfg.fixedFile == null then "" else cfg.fixedFile)}

        find_wallpapers() {
          ${pkgs.findutils}/bin/find -L "$wallpaper_dir" -maxdepth 1 -type f \
            \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.bmp' \
            -o -iname '*.gif' -o -iname '*.webp' -o -iname '*.jxl' -o -iname '*.avif' \
            -o -iname '*.heif' -o -iname '*.exr' \) 2>/dev/null \
            | ${pkgs.coreutils}/bin/sort
        }

        case "$initial_strategy" in
          none)
            exit 0
            ;;
          fixed)
            wallpaper_path="$wallpaper_dir/$fixed_file"
            ;;
          random)
            wallpaper_path="$(find_wallpapers | ${pkgs.coreutils}/bin/shuf -n 1)"
            ;;
          first)
            wallpaper_path="$(find_wallpapers | ${pkgs.coreutils}/bin/head -n 1)"
            ;;
        esac

        if [ -z "$wallpaper_path" ] || [ ! -f "$wallpaper_path" ]; then
          echo "No wallpaper selected from $wallpaper_dir; skipping DMS wallpaper configuration." >&2
          exit 0
        fi

        session_dir="$(${pkgs.coreutils}/bin/dirname "$session_file")"
        run ${pkgs.coreutils}/bin/mkdir -p "$session_dir"

        tmp_file="$(${pkgs.coreutils}/bin/mktemp)"
        if [ -s "$session_file" ] && ${pkgs.jq}/bin/jq -e . "$session_file" >/dev/null 2>&1; then
          ${pkgs.jq}/bin/jq --arg wallpaper "$wallpaper_path" '
            .wallpaperPath = $wallpaper
            | .wallpaperPathLight = $wallpaper
            | .wallpaperPathDark = $wallpaper
            | .perMonitorWallpaper = false
            | .monitorWallpapers = {}
            | .monitorWallpapersLight = {}
            | .monitorWallpapersDark = {}
          ' "$session_file" > "$tmp_file"
        else
          ${pkgs.jq}/bin/jq -n --arg wallpaper "$wallpaper_path" '{
            wallpaperPath: $wallpaper,
            wallpaperPathLight: $wallpaper,
            wallpaperPathDark: $wallpaper,
            perMonitorWallpaper: false,
            monitorWallpapers: {},
            monitorWallpapersLight: {},
            monitorWallpapersDark: {}
          }' > "$tmp_file"
        fi

        run ${pkgs.coreutils}/bin/install -m 0644 "$tmp_file" "$session_file"
        run ${pkgs.coreutils}/bin/rm -f "$tmp_file"

        profile_dms=${lib.escapeShellArg "/etc/profiles/per-user/${config.home.username}/bin/dms"}
        if [ -x "$profile_dms" ]; then
          run "$profile_dms" ipc call wallpaper set "$wallpaper_path" >/dev/null 2>&1 || true
        elif command -v dms >/dev/null 2>&1; then
          dms_bin="$(command -v dms)"
          run "$dms_bin" ipc call wallpaper set "$wallpaper_path" >/dev/null 2>&1 || true
        fi
      ''
    );
  };
}
