{
  nixpkgs,
  nixpkgs-unstable,
  home-manager,
  inputs,
  system,
}:
let
  nixosModulesPath = ./modules/nixos;

  mkPkgsUnstable =
    system:
    import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };

  pkgsUnstable = mkPkgsUnstable system;
in
{
  inherit mkPkgsUnstable pkgsUnstable;

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
        inherit pkgsUnstable;
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
