# Enable the generic graphics stack for desktop, gaming, and media workloads.
{
  lib,
  ...
}:

{
  config = {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
