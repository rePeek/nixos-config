{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  # https://devenv.sh/packages/
  packages = [
    pkgs.git
    pkgs.just
    pkgs.nixfmt-rfc-style
  ];

  languages.nix.enable = true;

  # https://devenv.sh/git-hooks/
  git-hooks.hooks.nixfmt-rfc-style.enable = true;

  # See full reference at https://devenv.sh/reference/options/
}
