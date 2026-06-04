# ssd.nix
# Periodically discard unused blocks on SSD storage.
{ config, lib, ... }:

let
  cfg = config.custom.features.storage.ssd;
in
{
  options.custom.features.storage.ssd.enable = lib.mkEnableOption "periodic SSD trim";

  config = lib.mkIf cfg.enable {
    services.fstrim.enable = true;
  };
}
