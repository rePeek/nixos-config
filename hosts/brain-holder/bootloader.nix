{ pkgs, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  # boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelPackages = pkgs.linuxPackages;
  boot.blacklistedKernelModules = [ "k10temp" ];
  boot.kernel.sysctl = {
    "kernel.split_lock_mitigate" = 0;
  };
  # boot.kernel = lib.mkMerge  = ["amd_pstate=active"];
  # 让系统支持 ntfs 文件系统，还需要安装 ntfs-3g
  boot.supportedFilesystems = [ "ntfs" ];
  environment.systemPackages = [ pkgs.ntfs3g ];
}
