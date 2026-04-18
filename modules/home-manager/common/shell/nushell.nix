{ pkgs, ... }:
{
  programs = {
    nushell = {
      enable = true;
      configFile.source = ./utils/just.nu;
      extraConfig = ''
        let carapace_completer = {|spans|
        carapace $spans.0 nushell ...$spans | from json
        }
        $env.config = {
         show_banner: false,
         completions: {
         case_sensitive: false # case-sensitive completions
         quick: true    # set to false to prevent auto-selecting completions
         partial: true    # set to false to prevent partial filling of the prompt
         algorithm: "fuzzy"    # prefix or fuzzy
         external: {
         # set to false to prevent nushell looking into $env.PATH to find more suggestions
             enable: true
         # set to lower can improve completion performance at the cost of omitting some options
             max_results: 100
             completer: $carapace_completer # check 'carapace_completer'
           }
         }
        }
      '';
      environmentVariables = {
        EDITOR = "hx";
        VISUAL = "hx";
      };
    };

    fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting # Disable greeting
      '';

      plugins = [
        {
          name = "plugin-git";
          src = pkgs.fishPlugins.plugin-git.src;
        }
        {
          name = "bass";
          src = pkgs.fishPlugins.bass.src;
        }
      ];
    };
    carapace.enable = true;
    carapace.enableNushellIntegration = true; # 必须显式设置为 true

    # Prompt theme
    starship = {
      enable = true;
      enableNushellIntegration = true;

      settings = {
        add_newline = false;
        format = ''
          [╭{OwO} ](bold green)$username$directory$battery$all$line_break$character
        '';
        right_format = ''
          $git_branch$git_state$git_status$time$cmd_duration
        '';
        character = {
          success_symbol = "[╰─>](bold green)";
          error_symbol = "[x─>](bold red)";
        };
        git_branch = {
          format = "[ $symbol$branch]($style) ";
          style = "cyan";
        };
        directory = {
          format = "[](fg:#a3ca5c bg:none)[$path]($style)[ ](fg:#a3ca5c bg:none)";
          style = "fg:#000000 bg:#a3ca5c";
          truncate_to_repo = false;
        };
        username.show_always = true;
        time.disabled = false;
        cmd_duration = {
          min_time = 0;
          disabled = false;
        };
        battery.disabled = false;
      };
    };
  };
}
