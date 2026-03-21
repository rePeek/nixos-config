{
  description = "Asen's NixOS flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/Hyprland";
      submodules = true;
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    daeuniverse.url = "github:daeuniverse/flake.nix";

    nix-ai-tools.url = "github:numtide/nix-ai-tools";

    llm-agents.url = "github:numtide/llm-agents.nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      mkNixosConfig =
        hostName: usernames:
        let
          specialArgs = { inherit inputs; };
        in
        nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "x86_64-linux";
          modules = [
            (./hosts + "/${hostName}")
            inputs.disko.nixosModules.disko
            inputs.daeuniverse.nixosModules.daed

            home-manager.nixosModules.home-manager
            (import ./modules/nixos/common/home-manager.nix {
              inherit inputs;
              hostName = hostName;
              usernames = usernames;
            })
          ];
        };
    in
    {
      nixosConfigurations = {
        brain-holder = mkNixosConfig "brain-holder" [ "asen" ];
      };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt;

      # None nixos systerm
      homeConfigurations."root" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          ./hosts/nixos-in-docker/root.nix
        ];
        extraSpecialArgs.inputs = inputs;
      };
    };
}
