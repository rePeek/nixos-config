{
  programs.fzf = {
    enable = true;

    defaultOptions = [
      "--height 60%"
      "--border"
      "--ansi"
      "--highlight-line"
      "--preview 'cat {}'"
    ];
  };
}
