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
        format = "$jobs$time$all";
        time = {
          disabled = false;
          time_format = "%R";
          style = "bright-grey bold";
          format = "[  $time ]($style)";
        };

        hostname = {
          ssh_symbol = "HUAWEI";
          format = "[$ssh_symbol](#d65d0e) on [$hostname ]($style)";
          style = "bright-green bold";
          ssh_only = true;
        };

        git_branch = {
          only_attached = true;
          format = "[ $branch](bright-yellow bold)";
        };

        git_commit = {
          only_detached = true;
          format = "[ $hash](bright-yellow bold)";
        };

        git_state = {
          style = "bright-purple bold";
        };

        git_status = {
          style = "bright-green bold";
        };

        directory = {
          read_only = " ";
          truncation_length = 3;
          truncation_symbol = "...";
        };

        cmd_duration = {
          format = " [$duration]($style) ";
          style = "bright-blue";
        };

        jobs = {
          style = "bright-green bold";
        };

        character = {
          success_symbol = "[❯](bold green)";
          error_symbol = "[✗](bold red)";
        };

        python = {
          format = "[$symbol $pyenv_prefix($version )(\\($virtualenv\\))]($style) ";
          symbol = "";
          version_format = "$raw";
          style = "bold yellow";
        };

        nix_shell = {
          symbol = "❄️ ";
          format = "via [$symbol$name]($style) ";
        };

        container = {
          disabled = true;
        };
      };
    };
  };
}
