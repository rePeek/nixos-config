{ pkgs, ... }:
{
  # 让系统支持 ntfs 文件系统，还需要安装 ntfs-3g
  boot.supportedFilesystems = [ "ntfs" ];
  environment.systemPackages = [ pkgs.ntfs3g ];
}
