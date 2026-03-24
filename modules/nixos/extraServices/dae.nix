{
  config,
  lib,
  inputs,
  ...
}:
with lib;
let
  cfg = config.modules.network.daed;
in
{
  imports = [
    inputs.daeuniverse.nixosModules.daed
  ];

  options.modules.network.daed = {
    enable = mkEnableOption "daed VPN client.";
  };

  config = mkIf cfg.enable {
    services = {
      daed = {
        enable = true;

        openFirewall = {
          enable = true;
          port = 12345;
        };

        configDir = "/etc/dae-wing";
        listen = "127.0.0.1:2023";
      };
    };
  };
}
