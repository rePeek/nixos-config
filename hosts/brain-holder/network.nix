{ pkgs, ... }:
{
  networking = {
    hostName = "brain-holder";
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
        5244

        #jellyfin
        8096
      ];
      allowedUDPPorts = [
        #jellyfin
        7359
      ];
    };
  };

  environment.systemPackages = with pkgs; [ networkmanagerapplet ];
}
