{ inputs, pkgs, ... }:

{
  environment.systemPackages = [
    inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  age.secrets.helloworld = {
    file = inputs.self + /secrets/helloworld.age;
    owner = "root";
    group = "root";
    mode = "0400";
  };

}
