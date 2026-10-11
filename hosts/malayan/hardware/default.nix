# Hardware facts are generated on the target cloud instance.
{
  imports = [
    ./hardware-configuration.nix
    ./filesystem.nix
  ];

  # Keep the cloud serial console available for boot diagnostics and recovery.
  boot.kernelParams = [
    "console=tty0"
    "console=ttyS0,115200n8"
  ];
}
