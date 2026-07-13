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

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dms = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
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

    zjstatus = {
      url = "github:dj95/zjstatus";
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
        # daily use
        brain-holder = myLib.mkHost {
          hostPath = ./hosts/brain-holder;
          hostName = "brain-holder";
          usernames = [ "asen" ];
        };

        home-server = myLib.mkHost {
          hostPath = ./hosts/home-server;
          hostName = "home-server";
          enableHomeManager = false;
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

        laiku = myLib.mkHost {
          hostPath = ./hosts/laiku;
          hostName = "laiku";
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
