{
  networking = {
    networkmanager = {
      enable = true;

      ensureProfiles.profiles.wired-gateway = {
        connection = {
          id = "wired-gateway";
          type = "ethernet";
          interface-name = "eno1";
          autoconnect = true;
        };

        ipv4 = {
          method = "manual";
          addresses = "192.168.137.16/24";
          gateway = "192.168.137.1";
          dns = "1.1.1.1;8.8.8.8;";
        };

        ipv6.method = "ignore";
      };
    };

    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
  };
}
