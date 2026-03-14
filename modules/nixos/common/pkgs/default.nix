{ pkgs, ... }:
{
  imports = [
    ./steam.nix
    # ./nix-ai.nix
  ];

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    curl
    git
    sysstat
    lm_sensors # for `sensors` command
    # minimal screen capture tool, used by i3 blur lock to take a screenshot
    # print screen key is also bound to this tool in i3 config
    scrot
    fastfetch
    zip
    xfce.thunar # xfce4's file manager
    # telegram-desktop
    #
    git-filter-repo
    devbox
    webp-pixbuf-loader
    nixfmt-rfc-style
    # openlist
  ];
}
