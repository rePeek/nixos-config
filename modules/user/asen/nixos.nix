# Shared system account profile for the asen user.
{
  config,
  lib,
  options,
  pkgs,
  ...
}:

let
  cfg = config.custom.users.asen;
  hasDesktopAvatar = lib.hasAttrByPath [
    "custom"
    "desktop"
    "avatar"
    "users"
  ] options;
in
{
  options.custom.users.asen = {
    extraGroups = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Additional groups for the asen system account on this host.";
    };
  };

  config = lib.mkIf (lib.elem "asen" config.custom.users.enabled) (
    {
      users.users.asen = {
        isNormalUser = true;
        description = "asen";
        home = "/home/asen";
        extraGroups = cfg.extraGroups;
        shell = pkgs.nushell;
        openssh.authorizedKeys.keys = config.custom.ssh.sharedAuthorizedKeys;
      };

      # Allow the user's flakes and command-line invocations to opt into extra substituters.
      nix.settings = {
        trusted-users = [ "asen" ];
        allowed-users = [ "asen" ];
      };
    }
    // lib.optionalAttrs hasDesktopAvatar {
      custom.desktop.avatar.users.asen = lib.mkDefault ../../../assets/avatars/asen.jpg;
    }
  );
}
