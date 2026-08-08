{
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;

    settings = {
      mgr = {
        show_hidden = true;
      };
      opener = {
        edit = [
          {
            block = true;
            run = "nvim \"$@\"";
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
