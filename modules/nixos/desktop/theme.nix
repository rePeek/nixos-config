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

  scheme = {
    yaml = "${inputs.tinted-schemes}/base16/${cfg.scheme}.yaml";
    use-ifd = "always";
  };
in
{
  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  options.custom.desktop.theme = {
    enable = lib.mkEnableOption "Stylix desktop theme profile";

    scheme = lib.mkOption {
      type = lib.types.str;
      default = "dracula";
      description = ''
        Base16 scheme name resolved from the tinted-theming/schemes flake
        input without the .yaml suffix.
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

  config = lib.mkIf cfg.enable {
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
          desktop = 12;
          popups = 12;
          terminal = 12;
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
