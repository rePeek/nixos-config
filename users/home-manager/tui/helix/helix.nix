{ pkgs, ... }:

let
  yazi-picker = "~/.config/scripts/yazi-picker.sh";
in
{
  xdg.configFile."scripts/yazi-picker.sh".source = ./yazi-picker.sh;
  programs.helix = {
    enable = true;
    defaultEditor = true;

    languages = {
      language = [
        {
          name = "cpp";
          auto-format = true;
          language-servers = [ "clangd" ];
        }
        {
          name = "cmake";
          auto-format = true;
          language-servers = [ "neocmakelsp" ];
        }
      ];

      language-server.clangd = {
        command = "clangd";
        config = {
          fallbackFlags = [ "-std=c++17" ];
        };
      };
      language-server.neocmakelsp = {
        command = "neocmakelsp";
        args = [ "--stdio" ];
      };
    };

    settings = {
      theme = "ashen";

      editor = {
        auto-save.after-delay.enable = true;
        soft-wrap.enable = true;
        lsp.display-messages = true;
        true-color = true;
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
      };

      keys.normal = {
        space.e = "file_picker_in_current_buffer_directory";
        space.w = ":w";
        space.q = ":q";
        space.x = ":bc";
        x = "select_line_below";
        X = "select_line_above";
        space.space = ":reset-diff-change";
        C-y = ":sh zellij run -c -f -x 10%% -y 10%% --width 80%% --height 80%% -- bash ${yazi-picker} open";
        S-left = ":buffer-previous";
        S-right = ":buffer-next";
        C-left = "jump_backward";
        C-right = "jump_forward";
        C-l = [
          ":write-all"
          ":sh zellij run -c -f -x 10%% -y 10%% --width 80%% --height 80%% -- lazygit"
        ];
        esc = [
          "collapse_selection"
          "keep_primary_selection"
        ];
      };
    };

    extraPackages = with pkgs; [
      nil
      marksman
      neocmakelsp
      typescript-language-server
      python313Packages.python-lsp-server
      # dap
      lldb
    ];
  };
}
