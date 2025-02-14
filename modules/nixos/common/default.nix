{ ... }:
{
  imports = [
    ./pkgs
    ./extraServices
    ./nix.nix
    ./pipewire.nix
    ./program.nix
    ./security.nix
    ./services.nix
    ./system.nix
    ./wayland.nix
    ./xserver.nix
  ];
}
