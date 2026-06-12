# Wallpaper component options and validation for the desktop profile.
{
  config,
  lib,
  ...
}:

let
  cfg = config.custom.desktop.components.wallpaper;
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
in
{
  options.custom.desktop.components.wallpaper = {
    enable = lib.mkEnableOption "desktop wallpaper component";

    directory = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Directory containing wallpaper images for desktop users.";
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
      description = "Link wallpaper images into each desktop user's wallpaper collection.";
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
        message = "custom.desktop.components.wallpaper.directory must be set when wallpaper component is enabled.";
      }
      {
        assertion = wallpaperNames != [ ] || cfg.initialStrategy == "none";
        message = "custom.desktop.components.wallpaper.directory does not contain any supported wallpaper image.";
      }
      {
        assertion =
          cfg.initialStrategy != "fixed" || (cfg.fixedFile != null && lib.elem cfg.fixedFile wallpaperNames);
        message = "custom.desktop.components.wallpaper.fixedFile must name an image in the wallpaper directory.";
      }
    ];
  };
}
