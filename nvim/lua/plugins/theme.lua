return {
  "ellisonleao/gruvbox.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("gruvbox").setup({
      contrast = "hard", -- soft | medium | hard
    })
    vim.cmd.colorscheme("gruvbox")
  end,
}
