# System user profiles enabled by each host.
{
  hostUsernames ? [ ],
  lib,
  ...
}:
{
  imports = [
    ./asen/nixos.nix
  ];

  options.custom.users.enabled = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = hostUsernames;
    defaultText = lib.literalExpression "mkHost usernames";
    description = "System user profiles enabled on this host.";
  };
}
