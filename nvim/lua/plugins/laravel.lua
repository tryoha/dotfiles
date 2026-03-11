return {
  "adibhanna/laravel.nvim",
  ft = { "php", "blade" },
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
  },
  keys = {
    { "<leader>la", ":Artisan<cr>", desc = "Laravel: Artisan" },
    { "<leader>lc", ":Composer<cr>", desc = "Laravel: Composer" },
    { "<leader>lr", ":LaravelRoute<cr>", desc = "Laravel: Routes" },
    { "<leader>lm", ":LaravelMake<cr>", desc = "Laravel: Make" },
  },
  config = function()
    require("laravel").setup({ keymaps = false })
  end,
}
