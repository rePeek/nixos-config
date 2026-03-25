{ config, lib, ... }:

let
  cfg = config.modules.powerManagement;
in
{
  options.modules.powerManagement = {
    type = lib.mkOption {
      type = lib.types.enum [
        "workstation"
        "laptop"
      ];
      default = "workstation";
      description = "Power management profile.";
    };
  };

  config = {
    # 工作站固定性能模式
    powerManagement.cpuFreqGovernor = lib.mkIf (cfg.type == "workstation") "performance";

    # 现在并没有 laptop 设备
    services = lib.mkMerge [
      (lib.mkIf (cfg.type == "laptop") {
        tuned = {
          enable = true;
          settings.dynamic_tuning = true; # 根据负载动态调整
          ppdSupport = true; # 允许 GNOME/KDE 等桌面切换电源配置
        };
        upower.enable = true; # 提供电池状态，供 tuned-ppd 使用
        power-profiles-daemon.enable = false;
        tlp.enable = false;
      })
    ];
  };
}
