{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.myModule.agenix;
in
{
  imports = [
    inputs.agenix.nixosModules.default
  ];

  options.myModule.agenix = {
    enable = lib.mkEnableOption "agenix support";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
