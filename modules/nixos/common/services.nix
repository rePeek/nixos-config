{ pkgs, ... }:
{
  services = {
    # Enable CUPS to print documents.
    printing.enable = true;
    gvfs.enable = true;
    gnome = {
      tinysparql.enable = true;
      gnome-keyring.enable = true;
    };
    dbus.enable = true;
    fstrim.enable = true;

    # 启用 power-profiles-daemon 后，用户可以通过桌面环境（如 GNOME、KDE 等）或命令行工具（如 powerprofilesctl）来切换和管理电源模式。
    # 该服务通常用于优化笔记本电脑或台式机的电源使用，以在性能和电池续航之间取得平衡
    power-profiles-daemon = {
      enable = true;
    };
    # 地理位置
    geoclue2.enable = true;
    # needed for GNOME services outside of GNOME Desktop
    dbus.packages = with pkgs; [
      gcr
      gnome-settings-daemon
    ];

    # only for laptop
    # logind.extraConfig = ''
    #   # don’t shutdown when power button is short-pressed
    #   HandlePowerKey=ignore
    # '';
  };
}
