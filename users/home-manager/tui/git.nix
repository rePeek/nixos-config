{
  programs = {
    diff-so-fancy = {
      enable = true;
    };

    git = {
      enable = true;      
      settings.extraConfig = {
        core.editor = "hx";
        pull.rebase = true;
      };
    };

    lazygit = {
      enable = true;
      settings = {
        gui = {
          theme = {
            activeBorderColor = [
              "#91d7e3"
              "bold"
            ];
            inactiveBorderColor = [ "#a5adcb" ];
            optionsTextColor = [ "#8aadf4" ];
            selectedLineBgColor = [ "#363a4f" ];
            cherryPickedCommitBgColor = [ "#494d64" ];
            cherryPickedCommitFgColor = [ "#91d7e3" ];
            unstagedChangesColor = [ "#ed8796" ];
            defaultFgColor = [ "#cad3f5" ];
            searchingActiveBorderColor = [ "#eed49f" ];
          };

          authorColors."*" = "#b7bdf8";
        };
        git = {
          # Improves performance
          # https://github.com/jesseduffield/lazygit/issues/2875#issuecomment-1665376437
          log.order = "default";

          fetchAll = false;
        };
      };
    };
  };

  home.shellAliases = {
    lg = "lazygit";

    gfu = "git fetch upstream";
    gfo = "git fetch origin";
  };
}
