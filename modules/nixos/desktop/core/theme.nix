# Stylix-backed desktop theme profile.
{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.custom.desktop.theme;

  customSchemes = {
    wolf-alabaster-light = {
      system = "base16";
      name = "Wolf Alabaster Light";
      author = "Wolf <wolf@zv.cx>, adapted to Base16 for Stylix";
      variant = "light";
      palette = {
        base00 = "#F7F7F7";
        base01 = "#F3F3F3";
        base02 = "#DDE7ED";
        base03 = "#777777";
        base04 = "#8090B8";
        base05 = "#000000";
        base06 = "#000000";
        base07 = "#000000";
        base08 = "#AA3731";
        base09 = "#7A3E9D";
        base0A = "#FFBC5D";
        base0B = "#448C27";
        base0C = "#8090B8";
        base0D = "#325CC0";
        base0E = "#007ACC";
        base0F = "#5A9DC4";
      };
    };

    wolf-alabaster-dark = {
      system = "base16";
      name = "Wolf Alabaster Dark";
      author = "Wolf <wolf@zv.cx>, adapted to Base16 for Stylix";
      variant = "dark";
      palette = {
        base00 = "#0E1415";
        base01 = "#141819";
        base02 = "#1E3A5F";
        base03 = "#8C8C8C";
        base04 = "#4A7090";
        base05 = "#CECECE";
        base06 = "#DFDFDF";
        base07 = "#F5F5F5";
        base08 = "#DFDF8E";
        base09 = "#CC8BC9";
        base0A = "#FF9800";
        base0B = "#95CB82";
        base0C = "#4A7090";
        base0D = "#71ADE7";
        base0E = "#CD974B";
        base0F = "#7A5B30";
      };
    };
  };

  scheme = customSchemes.${cfg.scheme} or "${pkgs.base16-schemes}/share/themes/${cfg.scheme}.yaml";
in
{
  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  options.custom.desktop.theme = {
    enable = lib.mkEnableOption "Stylix desktop theme profile";

    scheme = lib.mkOption {
      type = lib.types.str;
      default = "wolf-alabaster-light";
      description = ''
        Base16 scheme name. Built-in repository schemes take precedence; other
        names are resolved from pkgs.base16-schemes without the .yaml suffix.
      '';
      example = "gruvbox-material-light-soft";
    };

    polarity = lib.mkOption {
      type = lib.types.enum [
        "either"
        "light"
        "dark"
      ];
      default = "light";
      description = "Theme polarity passed to Stylix.";
    };

    image = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Wallpaper image used by Stylix targets that support wallpaper integration.";
      example = lib.literalExpression "../../assets/wallpapers/wallpaper.png";
    };

    imageScalingMode = lib.mkOption {
      type = lib.types.enum [
        "stretch"
        "fill"
        "fit"
        "center"
        "tile"
      ];
      default = "fill";
      description = "Scaling mode for the Stylix wallpaper image.";
    };
  };

  config = lib.mkIf (config.custom.desktop.enable && cfg.enable) {
    stylix = {
      enable = true;
      base16Scheme = lib.mkDefault scheme;
      polarity = lib.mkDefault cfg.polarity;
      imageScalingMode = lib.mkDefault cfg.imageScalingMode;

      cursor = {
        name = "Bibata-Modern-Ice";
        package = pkgs.bibata-cursors;
        size = 24;
      };

      fonts = {
        serif = {
          package = pkgs.source-serif;
          name = "Source Serif 4";
        };
        sansSerif = {
          package = pkgs.source-sans;
          name = "Source Sans 3";
        };
        monospace = {
          package = pkgs.maple-mono.NF-CN-unhinted;
          name = "Maple Mono NF CN";
        };
        emoji = {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };
        sizes = {
          applications = 12;
          desktop = 11;
          popups = 11;
          terminal = 14;
        };
      };

      icons = {
        enable = true;
        package = pkgs.papirus-icon-theme;
        light = "Papirus-Light";
        dark = "Papirus-Dark";
      };
    }
    // lib.optionalAttrs (cfg.image != null) {
      image = lib.mkDefault cfg.image;
    };
  };
}
