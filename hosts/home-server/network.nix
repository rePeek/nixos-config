{ ... }:
{
  networking = {
    hostName = "home-server";
    networkmanager.enable = true;
    nameservers = [
      "8.8.8.8"
      "8.8.4.4"
      "1.1.1.1"
      "114.114.114.114"
    ];
    firewall = {
      allowedTCPPorts = [
        22
        2023
        # ragflow
        49385
        # openclaw
        18789
        18790
      ];
    };

  };
}
