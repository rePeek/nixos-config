{
  programs.yazi = {
    enable = true;
    enableNushellIntegration = true;
    shellWrapperName = "y";

    settings = {
      mgr = {
        show_hidden = true;
      };
      opener = {
        edit = [
          {
            block = true;
            run = "hx \"$@\"";
          }
        ];
      };
      preview = {
        max_width = 1000;
        max_height = 1000;
      };
    };
  };
}
