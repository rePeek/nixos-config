{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.custom.service.fhs;
in
{
  options.custom.service.fhs.enable = lib.mkEnableOption "FHS and nix-ld compatibility layer";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      (
        let
          base = pkgs.appimageTools.defaultFhsEnvArgs;
        in
        pkgs.buildFHSEnv (
          base
          // {
            name = "fhs";
            targetPkgs = pkgs: (base.targetPkgs pkgs) ++ [ pkgs.pkg-config ];
            profile = "export FHS=1";
            runScript = "bash";
            extraOutputsToInstall = [ "dev" ];
          }
        )
      )
    ];

    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc
      ];
    };
  };
}
