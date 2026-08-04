# Conform — 格式化引擎（能力层）
# 只管格式化基础设施，具体 formatter 在 lang/*.nix
{
  plugins.conform-nvim = {
    enable = true;
    settings = {
      default_format_opts = {
        lsp_format = "fallback";
        async = true;
      };
    };
  };
}
