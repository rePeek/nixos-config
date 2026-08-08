{
  hostUsernames ? [ ],
  lib,
  ...
}:
{
  imports = [
    ./dank-material-shell.nix
  ];

  options.custom.desktop = {
    users = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = hostUsernames;
      defaultText = lib.literalExpression "mkHost usernames";
      description = "Users that receive the system desktop defaults through Home Manager.";
    };
  };
}
