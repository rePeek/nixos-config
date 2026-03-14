{ pkgs, ... }:

{
  imports = [
    ./zellij.nix
    ./shell
    ./helix
    ./btop.nix
    ./git.nix
    ./ghostty.nix
    ./rclone.nix
    ./openlist.nix
  ];
  home = {
    packages = with pkgs; [
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
      libsixel
      # Blue  dev, should comment in other machine
      git-repo
      git-lfs
      ffmpeg
      devenv

      _7zz
      unzip
      unrar

      nil
      python313Packages.markitdown
    ];
  };
}
