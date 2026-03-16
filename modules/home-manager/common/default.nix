{ pkgs, ... }:

{
  imports = [
    ./home.nix
    ./zellij.nix
    ./shell
    ./helix
    ./btop.nix
    ./git.nix
  ];
  home.packages = with pkgs; [
    # Rust implementations of linux commands
    bat # cat
    bottom # System monitor
    dust # du
    dua # du
    fd # find
    dysk
    procs # ps
    ripgrep
    just
    file
    wget
    xclip
    wl-clipboard
    repomix
    nixfmt
    nixfmt-tree
    _7zz
    unzip
    devenv
    difftastic
    lsof
  ];
}
