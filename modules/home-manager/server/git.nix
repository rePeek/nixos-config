{ pkgs, ... }:
{
  programs = {
    diff-so-fancy.enable = true;
    git = {
      enable = true;
      settings = {
        core.editor = "nvim";
        pull.rebase = true;
      };
    };

    lazygit = {
      enable = true;
      # Wrap lazygit to force legacy keyboard protocol in Ghostty,
      # fixing <esc> not working in sub-views (kitty keyboard protocol issue)
      package = pkgs.symlinkJoin {
        name = "lazygit";
        paths = [ pkgs.lazygit ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/lazygit \
            --set TCELL_KEYBOARD_PROTOCOL legacy
        '';
        meta.mainProgram = "lazygit";
      };
      settings = {
        git = {
          # Improves performance
          # https://github.com/jesseduffield/lazygit/issues/2875#issuecomment-1665376437
          log.order = "default";
          overrideGpg = true;
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
