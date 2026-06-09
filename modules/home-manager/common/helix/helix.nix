{
  config,
  lib,
  pkgs,
  ...
}:

let
  yazi-picker = "~/.config/scripts/yazi-picker.sh";
  blame_file_pretty = "~/.config/scripts/blame_file_pretty.sh";
  blame_line_pretty = "~/.config/scripts/blame_line_pretty.sh";
  git-hunk = "~/.config/scripts/git-hunk.sh";

  stylixColors = lib.attrByPath [ "lib" "stylix" "colors" "withHashtag" ] null config;
  stylixThemeEnabled = stylixColors != null;

  alabasterStylixTheme = colors: {
    warning = {
      fg = "highlight";
    };
    error = {
      fg = "error-red";
      modifiers = [ "bold" ];
    };
    info = {
      fg = "definition";
    };
    hint = {
      fg = "punctuation";
    };
    diagnostic = {
      underline.style = "curl";
    };

    "ui.background" = {
      bg = "bg";
    };
    "ui.text" = {
      fg = "fg";
    };
    "ui.text.focus" = {
      fg = "active";
      modifiers = [ "bold" ];
    };
    "ui.cursor" = {
      bg = "cursor-secondary";
      fg = "bg";
    };
    "ui.cursor.primary" = {
      bg = "active";
      fg = "bg";
    };
    "ui.cursor.match" = {
      fg = "active";
      underline.style = "line";
    };
    "ui.match" = {
      fg = "active";
      underline.style = "line";
    };
    "ui.cursorline.primary" = {
      bg = "cursorline-primary";
    };
    "ui.cursorline" = {
      bg = "cursorline";
    };
    "ui.cursorcolumn" = {
      bg = "cursorline";
    };
    "ui.gutter" = {
      bg = "bg";
    };
    "ui.selection" = {
      bg = "selection";
    };
    "ui.selection.primary" = {
      bg = "selection-primary";
    };
    "ui.linenr" = {
      fg = "punctuation";
    };
    "ui.linenr.selected" = {
      fg = "active";
      modifiers = [ "bold" ];
    };
    "ui.statusline" = {
      fg = "fg";
      bg = "panel";
    };
    "ui.statusline.inactive" = {
      fg = "punctuation";
      bg = "panel";
    };
    "ui.bufferline.active" = {
      fg = "fg";
      bg = "bg";
      modifiers = [ "bold" ];
    };
    "ui.bufferline.background" = {
      bg = "bg";
    };
    "ui.bufferline" = {
      fg = "punctuation";
      bg = "panel";
    };
    "ui.menu" = {
      fg = "fg";
      bg = "panel";
    };
    "ui.menu.selected" = {
      fg = "bg";
      bg = "active";
    };
    "ui.popup" = {
      fg = "fg";
      bg = "panel";
    };
    "ui.popup.info" = {
      fg = "fg";
      bg = "panel";
    };
    "ui.window" = {
      fg = "punctuation";
    };
    "ui.help" = {
      fg = "fg";
      bg = "bg";
    };
    "ui.virtual.jump-label" = {
      fg = "jump-label";
      modifiers = [ "bold" ];
    };
    "ui.virtual" = {
      fg = "inlay-hint";
    };
    "ui.virtual.inlay-hint" = {
      fg = "inlay-hint";
    };
    "ui.virtual.ruler" = {
      bg = "cursorline";
    };

    "diagnostic.error".underline = {
      color = "error-red";
      style = "curl";
    };
    "diagnostic.warning".underline = {
      color = "highlight";
      style = "curl";
    };
    "diagnostic.info".underline = {
      color = "definition";
      style = "curl";
    };
    "diagnostic.hint".underline = {
      color = "punctuation";
      style = "curl";
    };
    "diagnostic.deprecated" = {
      fg = "punctuation";
      modifiers = [ "crossed_out" ];
    };

    string = {
      fg = "string";
    };
    "string.regexp" = {
      fg = "string";
    };
    "string.special" = {
      fg = "string";
    };
    constant = {
      fg = "constant";
    };
    "constant.numeric" = {
      fg = "constant";
    };
    "constant.character" = {
      fg = "constant";
    };
    "constant.builtin" = {
      fg = "constant";
    };
    comment = {
      fg = "comment";
    };
    "comment.line" = {
      fg = "comment";
    };
    "comment.block" = {
      fg = "comment";
    };
    function = {
      fg = "definition";
    };
    "function.builtin" = {
      fg = "fg";
    };
    "function.method" = {
      fg = "definition";
    };
    "function.call" = {
      fg = "fg";
    };
    "function.method.call" = {
      fg = "fg";
    };
    constructor = {
      fg = "definition";
    };
    type = {
      fg = "fg";
    };
    "type.definition" = {
      fg = "definition";
    };
    "type.builtin" = {
      fg = "fg";
    };
    keyword = {
      fg = "fg";
    };
    "keyword.control" = {
      fg = "fg";
    };
    "keyword.operator" = {
      fg = "fg";
    };
    variable = {
      fg = "fg";
    };
    "variable.parameter" = {
      fg = "fg";
    };
    "variable.builtin" = {
      fg = "fg";
    };
    punctuation = {
      fg = "punctuation";
    };
    "punctuation.bracket" = {
      fg = "punctuation";
    };
    "punctuation.delimiter" = {
      fg = "punctuation";
    };
    operator = {
      fg = "punctuation";
    };
    tag = {
      fg = "definition";
    };
    "tag.error" = {
      fg = "error-red";
      underline.style = "line";
    };
    attribute = {
      fg = "fg";
    };
    namespace = {
      fg = "fg";
    };
    label = {
      fg = "constant";
    };

    "markup.heading" = {
      fg = "definition";
      modifiers = [ "bold" ];
    };
    "markup.list" = {
      fg = "fg";
    };
    "markup.bold" = {
      modifiers = [ "bold" ];
    };
    "markup.italic" = {
      modifiers = [ "italic" ];
    };
    "markup.link.url" = {
      fg = "string";
      modifiers = [ "underlined" ];
    };
    "markup.link.text" = {
      fg = "definition";
    };
    "markup.quote" = {
      fg = "comment";
    };
    "markup.raw" = {
      fg = "string";
    };
    "diff.plus" = {
      fg = "string";
    };
    "diff.minus" = {
      fg = "error-red";
    };
    "diff.delta" = {
      fg = "highlight";
    };

    palette = {
      fg = colors.base05;
      bg = colors.base00;
      string = colors.base0B;
      constant = colors.base09;
      comment = colors.base08;
      definition = colors.base0D;
      punctuation = colors.base03;
      selection = colors.base02;
      "selection-primary" = colors.base04;
      active = colors.base0E;
      "cursor-secondary" = colors.base0F;
      highlight = colors.base0A;
      "error-red" = colors.base08;
      panel = colors.base01;
      cursorline = colors.base01;
      "cursorline-primary" = colors.base02;
      "jump-label" = colors.base0A;
      "inlay-hint" = colors.base0C;
      "diff-green" = colors.base0B;
      "diff-red" = colors.base08;
      "diff-orange" = colors.base0A;
    };
  };
in
{
  home.activation.migrateHelixThemesDirectory = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    themesDir="${config.xdg.configHome}/helix/themes"

    if [ -L "$themesDir" ]; then
      target="$(readlink "$themesDir")"
      if [[ "$target" == /nix/store/* ]]; then
        run rm "$themesDir"
      fi
    fi
  '';

  xdg.configFile."scripts/yazi-picker.sh".source = ./yazi-picker.sh;
  xdg.configFile."scripts/blame_file_pretty.sh".source = ./blame_file_pretty.sh;
  xdg.configFile."scripts/blame_line_pretty.sh".source = ./blame_line_pretty.sh;
  xdg.configFile."scripts/git-hunk.sh".source = ./git-hunk.sh;
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

    themes = lib.mkIf stylixThemeEnabled {
      stylix = lib.mkForce (alabasterStylixTheme stylixColors);
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
