# pi-cc-extensions: Claude Code-style TUI rendering and richer diffs.
_: {
  programs.pi-coding-agent.settings.packages = [
    "npm:pi-cc-extensions"
  ];

  home.file.".pi/agent/claude-code-style.json".text = builtins.toJSON {
    mode = "on";
    diffViewMode = "auto";
    diffIndicatorMode = "bars";
    diffSplitMinWidth = 120;
    editDiffCollapsedLines = 24;
    writeDiffCollapsedLines = 0;
    diffWordWrap = true;
    enableSessionReference = true;
    enableSubagentAutocomplete = true;
  };
  home.file.".pi/agent/claude-code-style.json".force = true;
}
