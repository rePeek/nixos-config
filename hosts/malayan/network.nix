# Use the cloud DHCP lease; match the NIC by MAC rather than its kernel name.
{
  networking = {
    useDHCP = false;
    useNetworkd = true;
  };

  systemd.network.networks."10-uplink" = {
    matchConfig.MACAddress = "00:16:3e:72:8f:76";
    networkConfig.DHCP = "ipv4";
    linkConfig.RequiredForOnline = "routable";
  };
}
