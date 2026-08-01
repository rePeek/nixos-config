{
  networking = {
    networkmanager = {
      enable = true;

      ensureProfiles.profiles.ethernet = {
        connection = {
          id = "ethernet";
          type = "ethernet";
          interface-name = "eno1";
          autoconnect = true;
        };

        ipv4.method = "auto";

        ipv6.method = "ignore";
      };
    };

    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
  };
}
