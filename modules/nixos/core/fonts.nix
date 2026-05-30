# fonts.nix
# Install baseline fonts required by both desktop and server workloads.
{ pkgs, ... }:

{
  fonts = {
    fontDir.enable = true;

    packages = with pkgs; [
      noto-fonts
      noto-fonts-color-emoji
      source-han-mono
      source-han-sans
      source-han-serif
    ];
  };
}
