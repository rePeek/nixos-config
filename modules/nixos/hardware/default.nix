# default.nix
# Register reusable hardware capabilities. Hosts enable the required options.
{
  imports = [
    ./bluetooth.nix
    ./firmware.nix
    ./audio.nix
    ./cpu/intel.nix
    ./gpu/nvidia.nix
    ./kernel/cachyos.nix
    ./storage/ssd.nix
  ];
}
