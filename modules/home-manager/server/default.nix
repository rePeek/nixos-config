{ pkgs, nvimPkg, ... }:

{
  imports = [
    ./home.nix
    ./zellij.nix
    ./shell
    ./helix
    ./btop.nix
    ./git.nix
    ./pi
    ./llm-agents-package.nix
  ];
  home.packages = with pkgs; [
    nvimPkg

    # 系统监控与性能
    bottom
    procs

    # 文件与磁盘工具
    dust
    dua
    dysk
    fd
    ripgrep
    file
    zip
    unzip
    _7zz

    # 开发与代码工具
    bat
    difftastic
    nodejs
    repomix

    # misc
    xclip
    fastfetch
  ];
}
