{
  programs.btop = {
    enable = true;

    settings = {
      color_theme = "nightfox";
      vim_keys = true;
      update_ms = 1000;
      disks_filter = "";
      mem_graphs = false;
      proc_per_core = true;
    };
  };
}
