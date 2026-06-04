# Register reusable system capabilities. Hosts enable the required options.
{
  imports = [
    ./audio.nix
    ./bluetooth.nix
    ./firmware.nix
    ./cpu/intel.nix
    ./gpu/intel.nix
    ./gpu/nvidia.nix
    ./kernel/cachyos.nix
    ./storage/ssd.nix
  ];
}
