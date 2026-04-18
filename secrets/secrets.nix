let
  home-server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICL1tDbCxa8MbbUAAFDcvjVY+y8ULjLjL0tK78QWbtwJ root@home-server";
in
{
  "helloworld.age".publicKeys = [ home-server ];
}
