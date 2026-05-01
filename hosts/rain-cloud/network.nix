{ ... }:
{
  networking.useDHCP = false;

  networking.interfaces.ens18.ipv4.addresses = [
    {
      address = "172.16.125.116";
      prefixLength = 16;
    }
  ];

  networking.defaultGateway = {
    address = "172.16.0.1";
    interface = "ens18";
  };

  networking.nameservers = [
    "223.5.5.5"
    "8.8.8.8"
  ];
}
