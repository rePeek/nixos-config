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

    # 系统与存储状态
    bottom
    procs
    dust
    dua
    dysk

    # 文件查找与识别
    fd
    ripgrep
    file

    # 压缩与归档
    zip
    unzip
    _7zz

    # 开发与数据处理
    bat
    difftastic
    nodejs
    jq
    yq

    # 桌面与终端辅助
    xclip
    fastfetch
  ];
}
