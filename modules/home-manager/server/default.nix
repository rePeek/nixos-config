{ pkgs, nvimPkg, ... }:

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
    nvimPkg
    pi

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
    # Wayland 会话里 xclip 只写 XWayland 剪贴板，Hyprland 不会把它同步到 Wayland 剪贴板，
    # 于是 pi 等程序的复制表面上成功、粘出来却是旧内容；补上 wl-copy 让它们写入系统剪贴板。
    wl-clipboard
    fastfetch
  ];
}
