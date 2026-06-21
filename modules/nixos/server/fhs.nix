{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.custom.server.fhs;
in
{
  options.custom.server.fhs.enable = lib.mkEnableOption "FHS and nix-ld compatibility layer";

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
