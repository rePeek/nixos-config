{ ... }:
{
  imports = [
    ./container.nix
    ./nextcloud.nix
    ./dae.nix
    ./virtualization.nix
    ./jellyfin.nix
    ./greeted.nix
    # ./openlist.nix
  ];
}
