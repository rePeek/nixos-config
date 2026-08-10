# Enable Flatpak system-wide infrastructure.
# User-level Flatpak applications are managed by Home Manager via nix-flatpak.
{
  services.flatpak.enable = true;
}
