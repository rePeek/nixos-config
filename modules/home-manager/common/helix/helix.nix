{ pkgs, ... }:

let
  yazi-picker = "~/.config/scripts/yazi-picker.sh";
  blame_file_pretty = "~/.config/scripts/blame_file_pretty.sh";
  blame_line_pretty = "~/.config/scripts/blame_line_pretty.sh";
  git-hunk = "~/.config/scripts/git-hunk.sh";
in
{
  xdg.configFile."scripts/yazi-picker.sh".source = ./yazi-picker.sh;
  xdg.configFile."scripts/blame_file_pretty.sh".source = ./blame_file_pretty.sh;
  xdg.configFile."scripts/blame_line_pretty.sh".source = ./blame_line_pretty.sh;
  xdg.configFile."scripts/git-hunk.sh".source = ./git-hunk.sh;
  xdg.configFile."helix/themes".source = ./themes;
  programs.helix = {
    enable = true;
    defaultEditor = true;

    languages = {
      language = [
        {
          name = "cpp";
          # auto-format = true;
          language-servers = [ "clangd" ];
        }
        {
          name = "gas";
          language-servers = [ "asm-lsp" ];
        }
        {
          name = "nasm";
          language-servers = [ "asm-lsp" ];
        }
      ];
    };

    settings = {
      theme = "wolf-alabaster-dark";

      editor = {
        # inline-diagnostics
        end-of-line-diagnostics = "hint";
        inline-diagnostics.cursor-line = "warning";
        # ui
        true-color = true;
        soft-wrap.enable = true;
        lsp.display-messages = true;
        cursor-shape.insert = "bar";
        color-modes = true;
        statusline = {
          left = [
            "mode"
            "spinner"
          ];
          center = [ "file-name" ];
          right = [
            "diagnostics"
            "selections"
            "position"
            "file-encoding"
            "file-line-ending"
            "file-type"
          ];
          separator = "│";
          mode.normal = "NORMAL";
          mode.insert = "INSERT";
          mode.select = "SELECT";
        };
        # misc
        auto-save.after-delay.enable = true;
        clipboard-provider = "termcode";
      };

      keys.normal = {
        esc = [
          "collapse_selection"
          "keep_primary_selection"
        ];
        space.e = "file_picker_in_current_buffer_directory";
        space.w = ":w";
        space.q = ":q";
        space.x = ":bc";
        space.z = ":toggle gutters.line-numbers.min-width 52 3";
        space.space = ":reset-diff-change";
        x = "select_line_below";
        X = "select_line_above";
        S-left = ":buffer-previous";
        S-right = ":buffer-next";
        C-left = "jump_backward";
        C-right = "jump_forward";
        C-y = ":sh zellij run -c -f -x 10%% -y 10%% --width 80%% --height 80%% -- bash ${yazi-picker} open";
        C-l = [
          ":write-all"
          ":sh zellij run -c -f -x 10%% -y 10%% --width 80%% --height 80%% -- lazygit"
        ];
        A-b = ":echo %sh{git blame -L %{cursor_line},+1 %{buffer_name}}";
      };

      keys.normal.space.g = {
        f = "changed_file_picker";
        r = ":reset-diff-change";
        # inline blame
        b = ":sh ${blame_line_pretty} %{buffer_name} %{cursor_line}";
        # full last commit in the line changes for the file
        B = ":open %sh{bash ${blame_file_pretty} %{buffer_name} %{cursor_line}}";
        # inline hunk changes
        h = ":sh ${git-hunk} %{buffer_name} %{cursor_line} 3";
      };
    };

    extraPackages = with pkgs; [
      nil
      marksman
      cmake-language-server
      rust-analyzer
      asm-lsp
    ];
  };
}
