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
  customSchemes = import ../../../../theme/base16-schemes.nix;

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
      default = "wolf-alabaster-dark";
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
      default = "dark";
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
