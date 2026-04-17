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
        daemon.settings = {
          proxies = {
            http-proxy = "http://127.0.0.1:7897";
            https-proxy = "http://127.0.0.1:7897";
            no-proxy = "localhost,127.0.0.1";
          };
        };
        # 存储驱动，默认 overlay2 已足够
        storageDriver = "overlay2";
      };
    })

    (lib.mkIf cfg.libvirtd {
      environment.systemPackages = with pkgs; [
        virt-manager
        virt-viewer
        spice
        spice-gtk
        spice-protocol
        virtio-win
        win-spice
        adwaita-icon-theme
      ];
      virtualisation = {
        libvirtd = {
          enable = true;
          qemu = {
            swtpm.enable = true;
            ovmf.enable = true;
            ovmf.packages = [ pkgs.OVMFFull.fd ];
          };
        };
        spiceUSBRedirection.enable = true;
      };
      services.spice-vdagentd.enable = true;
    })
  ];
}
