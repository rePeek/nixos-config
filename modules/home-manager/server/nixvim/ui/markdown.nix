# render-markdown.nvim — Markdown 渲染（UI 层）
{
  plugins.render-markdown = {
    enable = true;
    settings = {
      render_modes = [
        "n"
        "c"
        "t"
      ];
      anti_conceal = {
        enabled = false;
      };
    };
  };
}
