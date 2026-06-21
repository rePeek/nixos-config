# Server NixOS profile. Hosts still opt into concrete services explicitly.
{
  imports = [
    ../core
    ./agenix.nix
    ./cli-proxy-api.nix
    ./fhs.nix
    ./mihomo.nix
    ../../user
    ./virtualization.nix
  ];
}
