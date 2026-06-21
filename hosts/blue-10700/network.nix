{ lib, ... }:

{
  networking = {
    networkmanager.enable = lib.mkForce false;
    useDHCP = false;

    interfaces = {
      eno1 = {
        useDHCP = false;
        ipv4.addresses = [
          {
            address = "192.168.137.16";
            prefixLength = 24;
          }
        ];
      };

      enp2s0.useDHCP = false;
    };

    defaultGateway = "192.168.137.1";

    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
  };
}
