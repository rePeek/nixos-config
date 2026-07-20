# Destructive layout for the replacement 2 TB SSD.
{
  fileSystems."/home/asen/data" = {
    device = "/dev/disk/by-uuid/a46aeb71-e82e-40c3-aade-b5e6edb7033c";
    fsType = "ext4";
  };

  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/disk/by-id/nvme-Fanxiang_S500PRO_2TB_FXS500PRO232144791";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          priority = 1;
          type = "EF00";
          size = "1G";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };

        swap = {
          size = "32G";
          content = {
            type = "swap";
            resumeDevice = true;
          };
        };

        root = {
          size = "100%";
          content = {
            type = "btrfs";
            extraArgs = [ "-f" ];
            subvolumes = {
              "/root" = {
                mountpoint = "/";
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];
              };
              "/home" = {
                mountpoint = "/home";
                mountOptions = [ "compress=zstd" ];
              };
              "/nix" = {
                mountpoint = "/nix";
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];
              };
            };
          };
        };
      };
    };
  };
}
