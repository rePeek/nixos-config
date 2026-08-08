{ usernames }:
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  desktopEnabled = lib.attrByPath [ "custom" "desktop" "enable" ] false config;
  desktopUsers = lib.attrByPath [ "custom" "desktop" "users" ] usernames config;

  monitorRuleType = lib.types.submodule {
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
  };

  userType = lib.types.submodule {
    options = {
      extraPackages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ ];
        description = "Extra Home Manager packages for this user on this host.";
      };

      desktop.hyprland.outputRules = lib.mkOption {
        type = lib.types.listOf monitorRuleType;
        default = [ ];
        description = "Host-specific Hyprland monitor rules for this user.";
      };

      desktop.extra.enable = lib.mkEnableOption "extra desktop applications for this user";

      desktop.cs2 = {
        enable = lib.mkEnableOption "CS2 launcher and configuration for this user";

        mangohud.enable = lib.mkEnableOption "MangoHud overlay" // {
          default = true;
        };

        gamescope = {
          enable = lib.mkEnableOption "Gamescope compositor" // {
            default = false;
          };

          args = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [
              "-W"
              "2560"
              "-H"
              "1440"
              "-r"
              "240"
              "--"
            ];
            description = "Arguments passed to gamescope before '--'.";
          };
        };
      };
    };
  };

  userHomeModule =
    username:
    let
      userCfg = config.custom.home.users.${username};
      userDesktopEnabled = desktopEnabled && lib.elem username desktopUsers;
      homeRole = if userDesktopEnabled then "desktop" else "server";
      userDesktopRole = homeRole == "desktop";
    in
    {
      imports = [
        ../home-manager/${homeRole}
        ../user/${username}/home.nix
      ];

      home.packages = userCfg.extraPackages;
    }
    // lib.optionalAttrs userDesktopRole {
      custom.desktop.cs2 = userCfg.desktop.cs2;
      custom.desktop.hyprland.outputRules = userCfg.desktop.hyprland.outputRules;
      custom.desktop.extra.enable = userCfg.desktop.extra.enable;
    };
in
{
  options.custom.home.users = lib.mkOption {
    type = lib.types.attrsOf userType;
    default = { };
    description = "Host-specific Home Manager defaults keyed by username.";
  };

  config = {
    custom.home.users = lib.genAttrs usernames (_username: { });

    home-manager = {
      # Use system pkgs so overlays stay consistent.
      useGlobalPkgs = true;
      # Install packages into the user environment.
      useUserPackages = true;
      backupFileExtension = "bkp";
      extraSpecialArgs = {
        inherit inputs;
        nvimPkg = inputs.nvim.packages.${pkgs.stdenv.hostPlatform.system}.default;
      };
      users = builtins.listToAttrs (
        map (username: {
          name = username;
          value = userHomeModule username;
        }) usernames
      );
    };
  };
}
