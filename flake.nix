{
  description = "Asen's NixOS flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-hardware = {
      url = "git+https://github.com/NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel/release";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dms = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    quickshell = {
      url = "github:quickshell-mirror/quickshell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    llm-agents.url = "github:numtide/llm-agents.nix";

    agenix.url = "github:ryantm/agenix";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixpkgs-unstable,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      myLib = import ./lib.nix {
        inherit nixpkgs;
        inherit nixpkgs-unstable;
        inherit home-manager;
        inherit inputs;
        inherit system;
      };
    in
    {
      nixosConfigurations = {
        # daily use
        brain-holder = myLib.mkHost {
          hostPath = ./hosts/brain-holder;
          hostName = "brain-holder";
          usernames = [ "asen" ];
        };

        home-server = myLib.mkHost {
          hostPath = ./hosts/home-server;
          hostName = "home-server";
          usernames = [ "asen" ];
        };

        rainyun = myLib.mkHost {
          hostPath = ./hosts/rain-cloud;
          enableHomeManager = false;
        };

        blue-10700 = myLib.mkHost {
          hostPath = ./hosts/blue-10700;
          hostName = "blue-10700";
          usernames = [ "asen" ];
        };
      };

      # None nixos systerm
      homeConfigurations."root" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [
          ./hosts/nixos-in-docker/root.nix
        ];
        extraSpecialArgs = {
          inherit inputs;
          inherit (myLib) pkgsUnstable;
        };
      };
    };
}
