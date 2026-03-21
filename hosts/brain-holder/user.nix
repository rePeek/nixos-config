{ pkgs, ... }:
{
  users.users.asen = {
    isNormalUser = true;
    description = "asen";
    home = "/home/asen";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
      "podman"
    ];
    shell = pkgs.nushell;
    # 需要加 openssh
  };

  # given the users in this list the right to specify additional substituters via:
  #    1. `nixConfig.substituers` in `flake.nix`
  #    2. command line args `--options substituers http://xxx`
  nix.settings.trusted-users = [ "asen" ];
  nix.settings.allowed-users = [ "asen" ];
}
