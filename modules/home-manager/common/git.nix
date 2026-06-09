{ pkgs, ... }:
{
  programs = {
    diff-so-fancy.enable = true;
    git = {
      enable = true;
      settings = {
        core.editor = "hx";
        pull.rebase = true;
      };
    };

    lazygit = {
      enable = true;
      settings = {
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

  home = {
    packages = with pkgs; [
      git-filter-repo

      git-repo
      git-lfs
    ];
  };
}
