{ ... }:
{
  imports = [
    ./container.nix
    ./nextcloud.nix
    ./dae.nix
    ./virtualization.nix
    ./jellyfin.nix
    ./greeted.nix
    ./tailscale.nix
    # ./openlist.nix
  ];
}
