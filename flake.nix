{
  description = "Asen's NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-hardware = {
      url = "git+https://github.com/NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel/release";
    };

    dms = {
      # Keep the locale-independent Bluetooth codec fix while retaining the
      # matching 1.6-beta configuration interface used by this repository.
      url = "github:AvengeMedia/DankMaterialShell/cf4f48069f24a522f0bab88f3523685bfe8f13da";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dank-greeter = {
      url = "github:AvengeMedia/dank-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.dank-qml-common.follows = "dms/dank-qml-common";
    };

    quickshell = {
      url = "github:quickshell-mirror/quickshell";
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

    llm-agents.url = "github:numtide/llm-agents.nix";

    agenix.url = "github:ryantm/agenix";

    leigod.url = "github:rePeek/leigod-plugin-linux";

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.7.0";

    nvim = {
      url = "github:rePeek/nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      git-hooks,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      preCommitCheck = git-hooks.lib.${system}.run {
        src = ./.;
        hooks.nixfmt.enable = true;
      };

      myLib = import ./lib.nix {
        inherit nixpkgs;
        inherit home-manager;
        inherit inputs;
        inherit system;
      };
    in
    {
      checks.${system}.pre-commit-check = preCommitCheck;

      devShells.${system}.default = pkgs.mkShell {
        inherit (preCommitCheck) shellHook;

        packages = with pkgs; [
          git
          just
          nixfmt
        ];

        buildInputs = preCommitCheck.enabledPackages;
      };

      nixosConfigurations = {
        amur = myLib.mkHost {
          hostPath = ./hosts/amur;
          usernames = [ "asen" ];
          extraModules = [ inputs.leigod.nixosModules.default ];
        };

        sumatran = myLib.mkHost {
          hostPath = ./hosts/sumatran;
          enableHomeManager = false;
        };

        malayan = myLib.mkHost {
          hostPath = ./hosts/malayan;
          enableHomeManager = false;
        };

        bengal = myLib.mkHost {
          hostPath = ./hosts/bengal;
          usernames = [ "asen" ];
        };

      };

      # None nixos systerm
      homeConfigurations."root" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          inputs.stylix.homeModules.stylix
          ./hosts/nixos-in-docker/root.nix
        ];
        extraSpecialArgs = {
          inherit inputs;
        };
      };
    };
}
