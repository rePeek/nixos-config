{ config, pkgs, ... }:
{
  users.users.asen = {
    isNormalUser = true;
    description = "asen";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    home = "/home/asen";
    shell = pkgs.nushell;
    openssh.authorizedKeys.keys = config.custom.ssh.sharedAuthorizedKeys ++ [
      # Windows game PC
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINGRn9IstM5aV2WO9aiT1XeGUKw/2aN+VR5GGYx0tny1 game@brain"
    ];
  };
  # given the users in this list the right to specify additional substituters via:
  #    1. `nixConfig.substituers` in `flake.nix`
  #    2. command line args `--options substituers http://xxx`
  nix.settings.trusted-users = [ "asen" ];
  nix.settings.allowed-users = [ "asen" ];
}
