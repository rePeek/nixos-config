{ config, ... }:
{
  home = {
    sessionVariables = {
      ANTHROPIC_BASE_URL = "https://api.deepseek.com/anthropic";
      ANTHROPIC_MODEL = "deepseek-chat";
      ANTHROPIC_SMALL_FAST_MODEL = "deepseek-chat";
    };
    stateVersion = "25.11"; # Please read the comment before changing.
  };

  home.file.".config/anthropic/env.sh" = {
    text = ''
      #!/bin/bash  
      export ANTHROPIC_AUTH_TOKEN=$(cat ${config.age.secrets.DEEPSEEK_API_KEY.path})  
    '';
    executable = true;
  };

  programs.home-manager.enable = true;
}
