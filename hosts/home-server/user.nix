{ pkgs, ... }:
{
  users.users.wanglei = {
    isNormalUser = true;
    description = "wanglei";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    home = "/home/wanglei";
    shell = pkgs.nushell;
    # openssh.authorizedKeys.keys = [
    # replace with your own public key
    #    "ssh-ed25519 <some-public-key> ryan@ryan-pc"
    #];
  };
  # given the users in this list the right to specify additional substituters via:
  #    1. `nixConfig.substituers` in `flake.nix`
  #    2. command line args `--options substituers http://xxx`
  nix.settings.trusted-users = [ "wanglei" ];
  nix.settings.allowed-users = [ "wanglei" ];
}
