{ hostName, usernames }:
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  home-manager = {
    # Use system pkgs so overlays stay consistent.
    useGlobalPkgs = true;
    # Install packages into the user environment.
    useUserPackages = true;
    backupFileExtension = "bkp";
    extraSpecialArgs = {
      inherit inputs;
    };
    users = builtins.listToAttrs (
      map (username: {
        name = username;
        value = import ../../hosts/${hostName}/users/${username}.nix;
      }) usernames
    );
  };
}
