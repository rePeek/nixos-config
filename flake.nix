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

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    daeuniverse.url = "github:daeuniverse/flake.nix";

    llm-agents.url = "github:numtide/llm-agents.nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        # daily use
        brain-holder = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/brain-holder
            inputs.disko.nixosModules.disko
            home-manager.nixosModules.home-manager
            (import ./modules/nixos/home-manager.nix {
              inherit inputs;
              hostName = "brain-holder";
              usernames = [ "asen" ];
            })
          ];
        };

        # home server
        home-server = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/home-server/configuration.nix
            home-manager.nixosModules.home-manager
            (import ./modules/nixos/home-manager.nix {
              inherit inputs;
              hostName = "home-server";
              usernames = [ "wanglei" ];
            })
          ];
        };
      };

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
