{
  nixpkgs,
  home-manager,
  inputs,
  system,
}:
let
  nixosModulesPath = ./modules/nixos;
in
{
  mkHost =
    {
      hostPath,
      hostName ? null,
      usernames ? [ ],
      enableHomeManager ? true,
      extraModules ? [ ],
    }:
    nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs;
        hostUsernames = usernames;
      };
      modules = [
        hostPath
        inputs.disko.nixosModules.disko
      ]
      ++ nixpkgs.lib.optionals enableHomeManager [
        home-manager.nixosModules.home-manager
        (import (nixosModulesPath + "/home-manager.nix") {
          inherit hostName usernames;
        })
      ]
      ++ extraModules;
    };
}
