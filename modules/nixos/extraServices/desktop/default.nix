{
  imports = [
    ./fonts.nix
    ./pipewire.nix
    ./greeted.nix
    ./bluetooth.nix
    ./misc.nix
  ];

  # 作用：启用 dconf 配置数据库。
  #  - dconf 是 GNOME 及许多 GTK 应用程序使用的底层配置存储系统，类似于 Windows 的注册表。它存储用户界面主题、字体、键盘布局等设置。
  #  - 如果你使用了任何需要保存图形界面配置的程序（例如 gnome-control-center、firefox 的 GTK 样式等），通常需要启用 dconf 来让这些设置正常工作。
  #  - 在 NixOS 中，如果禁用了 dconf，你可能会看到类似“无法写入设置”的警告或 GUI 程序配置无法保存。
  #  nixos 配置 (programs.dconf.enable)	启用 dconf 后台服务
  #  home-manager 配置 (dconf.settings)	写入具体的用户配置值
  programs.dconf.enable = true;
}
