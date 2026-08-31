# 系统排障与硬件诊断工具。
# 所有主机（含无 Home Manager 的服务器）都需要这些工具，
# 确保 root SSH 救援时即可使用。
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    lsof
    pciutils
    usbutils
    ethtool
    dnsutils
    nvme-cli
    lm_sensors
    sysstat # 若需历史采样，还需在主机侧启用 services.sysstat.enable
  ];
}
