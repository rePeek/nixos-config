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
        # 80
        # 443
        # 59010
        # 59011
      ];
      # allowedUDPPorts = [
      #   59010
      #   59011
      # ];
    };
  };

  environment.systemPackages = with pkgs; [ networkmanagerapplet ];
}
