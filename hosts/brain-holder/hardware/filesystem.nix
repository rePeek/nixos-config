{
  fileSystems."/home/asen/share" = {
    device = "/dev/disk/by-uuid/9498187F98186252";
    fsType = "ntfs-3g";
    options = [
      "rw"
      "uid=1000"
    ];
  };

  disko.devices = {
    disk = {
      data_public = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions.data = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/mnt/public_data";
            };
          };
        };
      };
    };
  };
}
