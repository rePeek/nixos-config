# Pi coding agent — Nix runtime wrapper via nixpi submodule.
#
# Applies the nixpi overlay so pkgs.pi is the wrapped version with stable
# runtime dependencies (node, npm, git, rg, coreutils). The wrapper manages
# config symlinks from the nix store snapshot of components/nixpi/config/.
{ inputs, ... }:

{
  nixpkgs.overlays = [
    inputs.nixpi.overlays.default
  ];
}
