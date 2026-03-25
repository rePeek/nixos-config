{
  # Add terminfo database of all known terminals to the system profile.
  # https://github.com/NixOS/nixpkgs/blob/nixos-25.11/nixos/modules/config/terminfo.nix
  environment.enableAllTerminfo = true;
  # 启用 libinput 处理输入设备（触摸板、鼠标、键盘等）。这是现代 Linux 桌面的标准，提供手势、滚动加速等功能。
  services.libinput.enable = true;
  # To prevent getting stuck at shutdown
  systemd.settings.Manager.DefaultTimeoutStopSec = "10s";

}
