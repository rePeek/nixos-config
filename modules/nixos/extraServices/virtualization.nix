{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.virtualization.custom;
in
{
  options.modules.virtualization.custom = {
    docker = lib.mkEnableOption "Docker container support";
    libvirtd = lib.mkEnableOption "Libvirtd/QEMU virtualization support";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.docker {
      virtualisation.docker = {
        enable = true;
        # 开机自启
        enableOnBoot = true;
        # 允许非 root 用户使用 Docker（将用户加入 docker 组）
        enableNvidia = false; # 如需 GPU 支持可开启
        # 自动清理镜像和容器（每周一次）
        autoPrune = {
          enable = true;
          dates = "weekly";
          flags = [
            "--filter=until=24h" # 清理 24 小时前创建的资源
            "--filter=label!=important"
          ];
        };
        # 存储驱动，默认 overlay2 已足够
        storageDriver = "overlay2";
      };
    })

    (lib.mkIf cfg.libvirtd {
      # 宿主机侧：启用 libvirt 图形管理工具
      programs.virt-manager.enable = true;

      environment.systemPackages = with pkgs; [
        # 图形控制台查看工具
        virt-viewer

        # SPICE 相关：
        # 用于图形控制台、剪贴板、动态分辨率、USB 重定向等
        spice
        spice-gtk
        spice-protocol

        # 某些环境里 virt-manager 显示会用到图标主题
        adwaita-icon-theme

        # libvirt 默认 NAT 网络常会依赖 dnsmasq
        dnsmasq
      ];

      virtualisation = {
        libvirtd = {
          enable = true;

          qemu = {
            # 需要 TPM 的 Linux guest 可直接使用
            swtpm.enable = true;

            # 25.11 不再写 ovmf.enable / ovmf.packages
            # 现在由 libvirt + qemu 的机制自动处理 UEFI 固件
          };
        };

        # 宿主机侧 USB 重定向支持
        spiceUSBRedirection.enable = true;
      };

      # libvirt 默认 NAT 网桥一般是 virbr0
      # 某些情况下不放行会影响 guest 网络
      networking.firewall.trustedInterfaces = [ "virbr0" ];
    })
  ];
}
