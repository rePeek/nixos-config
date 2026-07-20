{
  config,
  lib,
  pkgs,
  ...
}:

let
  stylixColors = lib.attrByPath [ "lib" "stylix" "colors" "withHashtag" ] null config;
  stylixEnabled = stylixColors != null;

  # Map base16 colors from Stylix to pi theme tokens.
  # Base16 spec:
  #   base00-bg base01-bg-alt base02-bg-select base03-comment
  #   base04-fg-dim base05-fg base06-fg-light base07-fg-lighter
  #   base08-red base09-orange base0A-yellow base0B-green
  #   base0C-cyan base0D-blue base0E-purple base0F-brown
  piStylixTheme = {
    name = "stylix";
    vars = {
      bg = stylixColors.base00;
      bg-alt = stylixColors.base01;
      bg-select = stylixColors.base02;
      comment = stylixColors.base03;
      fg-dim = stylixColors.base04;
      fg = stylixColors.base05;
      red = stylixColors.base08;
      orange = stylixColors.base09;
      yellow = stylixColors.base0A;
      green = stylixColors.base0B;
      cyan = stylixColors.base0C;
      blue = stylixColors.base0D;
      purple = stylixColors.base0E;
    };
    colors = {
      accent = "purple";
      border = "blue";
      borderAccent = "cyan";
      borderMuted = "bg-alt";
      success = "green";
      error = "red";
      warning = "yellow";
      muted = "comment";
      dim = "fg-dim";
      text = "";
      thinkingText = "comment";

      selectedBg = "bg-select";
      userMessageBg = "bg-alt";
      userMessageText = "";
      customMessageBg = "bg-alt";
      customMessageText = "";
      customMessageLabel = "purple";
      toolPendingBg = "bg-alt";
      toolSuccessBg = "bg-alt";
      toolErrorBg = "bg-alt";
      toolTitle = "purple";
      toolOutput = "";

      mdHeading = "yellow";
      mdLink = "blue";
      mdLinkUrl = "comment";
      mdCode = "cyan";
      mdCodeBlock = "";
      mdCodeBlockBorder = "comment";
      mdQuote = "comment";
      mdQuoteBorder = "comment";
      mdHr = "comment";
      mdListBullet = "cyan";

      toolDiffAdded = "green";
      toolDiffRemoved = "red";
      toolDiffContext = "comment";

      syntaxComment = "comment";
      syntaxKeyword = "purple";
      syntaxFunction = "blue";
      syntaxVariable = "yellow";
      syntaxString = "green";
      syntaxNumber = "orange";
      syntaxType = "cyan";
      syntaxOperator = "purple";
      syntaxPunctuation = "comment";

      thinkingOff = "comment";
      thinkingMinimal = "purple";
      thinkingLow = "blue";
      thinkingMedium = "cyan";
      thinkingHigh = "purple";
      thinkingXhigh = "red";
      thinkingMax = "orange";

      bashMode = "yellow";
    };
  };
in
{
  programs.pi-coding-agent = {
    enable = true;

    settings = {
      defaultProvider = "deepseek";
      defaultModel = "deepseek-v4-pro";
      defaultThinkingLevel = "high";

      # 做缓存实验时保留
      showCacheMissNotices = true;
    }
    // lib.optionalAttrs stylixEnabled {
      theme = "stylix";
    };

    models.providers.deepseek = {
      baseUrl = "https://api.deepseek.com";
      api = "openai-completions";

      models = [
        {
          id = "deepseek-v4-pro";

          reasoning = true;
          contextWindow = 1000000;
          maxTokens = 65536;

          thinkingLevelMap = {
            minimal = null;
            low = null;
            medium = null;
            high = "high";
            xhigh = null;
            max = "max";
          };
        }
      ];
    };
  };

  # Write a pi theme file derived from Stylix base16 colors.
  # pi discovers themes in ~/.pi/agent/themes/*.json and matches by name.
  home.file = lib.mkIf stylixEnabled {
    ".pi/agent/themes/stylix.json".text = builtins.toJSON piStylixTheme;
  };
}
