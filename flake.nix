{
  description = "Asen's NixOS flake";

  # the nixConfig here only affects the flake itself, not the system configuration!
  # for more information, see:
  #     https://nixos-and-flakes.thiscute.world/nix-store/add-binary-cache-servers
  nixConfig = {
    # substituers will be appended to the default substituters when fetching packages
    extra-substituters = [
      # cache mirror located in China
      # status: https://mirror.sjtu.edu.cn/
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      # status: https://mirrors.ustc.edu.cn/status/
      "https://mirrors.ustc.edu.cn/nix-channels/store"

      "https://nix-community.cachix.org"
      "https://cache.nixos.org"
      "https://cache.numtide.com"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

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
          usernames = [ "wanglei" ];
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
