# pi-hashline-edit plugin: stable line anchors for edit tool calls.
_: {
  programs.pi-coding-agent.settings.packages = [
    "npm:pi-hashline-edit"
  ];

  home.file.".pi/agent/hashline.json".force = true;
  home.file.".pi/agent/hashline.json".text = builtins.toJSON {
    hashLength = 3;
    grep = false;
    replaceText = false;
  };
}
