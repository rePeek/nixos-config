{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.custom.server.agenix;
in
{
  imports = [
    inputs.agenix.nixosModules.default
  ];

  options.custom.server.agenix = {
    enable = lib.mkEnableOption "agenix support";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
