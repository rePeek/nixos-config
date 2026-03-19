{ inputs, config, ... }:
{
  imports = [
    inputs.agenix.homeManagerModules.default
  ];

  age = {
    identityPaths = [
      "${config.home.homeDirectory}/.ssh/id_ed25519"
      "${config.home.homeDirectory}/.ssh/id_rsa"
    ];

    secrets = {
      DEEPSEEK_API_KEY = {
        file = ./DEEPSEEK_API_KEY.age;
      };
    };
  };
}
