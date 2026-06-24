{
  home.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";
  };

  programs = {
    nushell = {
      enable = true;
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

        # devenv sets a bash-style PS1 prefix like "(devenv)"; hide it so
        # Starship remains the single source of prompt rendering in Nushell.
        if "PS1" in $env {
          hide-env PS1
        }
      '';
    };

  };
}
