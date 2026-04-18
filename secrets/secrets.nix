let
  home-server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICL1tDbCxa8MbbUAAFDcvjVY+y8ULjLjL0tK78QWbtwJ root@home-server";
  brain-holder = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICX1IacqcOcccRKWpGVIZ55jLT0m9PdD7jS5EOyGQK6a root@nixos";
in
{
  "helloworld.age".publicKeys = [
    home-server
    brain-holder
  ];
  "flybit-subscription.age".publicKeys = [
    home-server
    brain-holder
  ];
}
