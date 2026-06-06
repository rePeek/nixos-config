{
  config,
  lib,
  ...
}:

let
  cfg = config.custom.tuning.builder;
in
{
  options.custom.tuning.builder = {
    enable = lib.mkEnableOption "builder-oriented system tuning";

    nix = {
      maxJobs = lib.mkOption {
        type = lib.types.int;
        default = 8;
        description = "Default nix.settings.max-jobs for builder hosts.";
      };

      cores = lib.mkOption {
        type = lib.types.int;
        default = 0;
        description = "Default nix.settings.cores for builder hosts.";
      };

      keepOutputs = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Keep build outputs by default on builder hosts.";
      };

      keepDerivations = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Keep derivations by default on builder hosts.";
      };

      maxSubstitutionJobs = lib.mkOption {
        type = lib.types.int;
        default = 16;
        description = "Default nix.settings.max-substitution-jobs for builder hosts.";
      };
    };

    power.profile = lib.mkOption {
      type = lib.types.enum [
        "performance"
        "efficiency"
      ];
      default = "performance";
      description = "Default power profile for builder hosts.";
    };

    remoteBuild = {
      speedFactor = lib.mkOption {
        type = lib.types.int;
        default = 1;
        description = "Default speed factor to describe this builder host.";
      };

      supportedFeatures = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "Default supported feature labels for remote builder declarations.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    custom.features.power.profile = lib.mkDefault cfg.power.profile;

    nix.settings = {
      max-jobs = lib.mkDefault cfg.nix.maxJobs;
      cores = lib.mkDefault cfg.nix.cores;
      keep-outputs = lib.mkDefault cfg.nix.keepOutputs;
      keep-derivations = lib.mkDefault cfg.nix.keepDerivations;
      max-substitution-jobs = lib.mkDefault cfg.nix.maxSubstitutionJobs;
    };
  };
}
