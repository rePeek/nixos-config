{
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
