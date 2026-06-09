{
  programs.ghostty = {
    enable = true;
    settings = {
      command = "nu --login";
      font-thicken = true;
      font-feature = [
        "ss04"
        "ss01"
      ];
      adjust-font-baseline = 0;

      bold-is-bright = false;
      adjust-box-thickness = 1;

      cursor-style = "bar";
      cursor-style-blink = false;
      adjust-cursor-thickness = 1;

      resize-overlay = "never";
      copy-on-select = true;
      confirm-close-surface = false;
      mouse-hide-while-typing = true;

      window-padding-x = 0;
      window-padding-y = 0;
      window-padding-balance = true;
      window-padding-color = "background";
      window-inherit-working-directory = true;
      window-inherit-font-size = true;
      window-decoration = false;

      gtk-titlebar = false;
      gtk-single-instance = false;
      gtk-tabs-location = "bottom";
      gtk-wide-tabs = false;

      auto-update = "off";
      term = "ghostty";
      clipboard-paste-protection = false;

      keybind = [
        "shift+end=unbind"
        "shift+home=unbind"
        "ctrl+shift+left=unbind"
        "ctrl+shift+right=unbind"
        "shift+enter=text:\\n"
      ];
    };
  };
}
