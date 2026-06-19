# Register reusable system capabilities. Hosts enable the required options.
{
  imports = [
    ./amd.nix
    ./audio.nix
    ./bluetooth.nix
    ./graphics.nix
    ./kernel/cachyos.nix
    ./nvidia.nix
    ./power.nix
    ./virtualization.nix
  ];
}
