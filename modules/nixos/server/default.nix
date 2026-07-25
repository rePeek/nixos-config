# Server NixOS profile. Hosts still opt into concrete services explicitly.
{
  imports = [
    ../core
    ./agenix.nix
    ./cpa
    ./fhs.nix
    ./mihomo.nix
    ../../user
    ./virtualization.nix
  ];
}
