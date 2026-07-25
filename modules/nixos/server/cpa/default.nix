# CLIProxyAPI — NixOS module entry.
{ lib, ... }:

let
  cfg = lib.mkEnableOption "CLIProxyAPI service";
in
{
  imports = [
    ./config.nix
    ./service.nix
  ];

  options.custom.server.cpa.enable = cfg;
}
