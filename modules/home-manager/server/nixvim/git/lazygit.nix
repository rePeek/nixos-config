# LazyGit — floating git terminal
{
  plugins.lazygit = {
    enable = true;
  };

  # ── Keymaps ──
  keymaps = [
    {
      key = "<leader>gg";
      mode = "n";
      action = "<cmd>LazyGit<CR>";
      options.desc = "LazyGit";
    }
  ];
}
