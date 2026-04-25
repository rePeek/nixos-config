{ pkgs, pkgsUnstable, ... }:

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
    # 系统监控与性能
    bottom
    sysstat # 提供 iostat、mpstat、sar 等性能工具, 若需收集历史数据，必须在系统侧启用 services.sysstat.enable = true，并配置收集间隔和保留天数。仅使用实时命令则可仅用户侧安装。
    procs
    lm_sensors # 必须在系统侧加载内核模块（如 coretemp、i2c-i801），通过 boot.kernelModules 添加；同时可能需要将用户加入 i2c 组才能读取 I²C 传感器。
    lsof

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
    just # should config in devenv
    pkgsUnstable.devenv
    difftastic
    repomix
    # should config in devenv
    nixfmt
    nixfmt-tree

    # misc
    xclip
    fastfetch
  ];
}
