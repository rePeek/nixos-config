# Server NixOS profile. Hosts still opt into concrete services explicitly.
{
  imports = [
    ../core
    ./agenix.nix
    ./bili-sync.nix
    ./cpa
    ./fhs.nix
    ./mihomo.nix
    ./pi.nix
    ../../user
    ./virtualization.nix
  ];
}
