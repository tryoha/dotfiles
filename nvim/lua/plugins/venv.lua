return {
  "linux-cultist/venv-selector.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  lazy = vim.g.bootstrap,
  config = function()
    require("venv-selector").setup({
      -- минимальный конфиг без спорных ключей
      name = { "venv", ".venv", "env" },
      auto_refresh = true,
    })

    vim.keymap.set("n", "<leader>vs", "<cmd>VenvSelect<cr>", { desc = "Select venv" })
    vim.keymap.set("n", "<leader>vc", "<cmd>VenvSelectCached<cr>", { desc = "Select cached venv" })
  end,
}
