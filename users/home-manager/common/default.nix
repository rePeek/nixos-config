{pkgs, ... }:

{
  imports = [
    ./zellij.nix
    ./shell
    ./helix
    ./btop.nix
    ./git.nix
    ./llm-agents-package.nix
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

    git
    wget
    xclip

    # Blue  dev, should comment in other machine
    # git-repo
    git-lfs
    rustc
    cargo
    repomix

    nixfmt
    nixfmt-tree
  ];
}
