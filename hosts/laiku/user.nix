{ config, pkgs, ... }:
{
  users.users.asen = {
    isNormalUser = true;
    description = "asen";
    home = "/home/asen";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.nushell;
    openssh.authorizedKeys.keys = config.custom.ssh.sharedAuthorizedKeys;
  };

  nix.settings.trusted-users = [ "asen" ];
  nix.settings.allowed-users = [ "asen" ];
}
