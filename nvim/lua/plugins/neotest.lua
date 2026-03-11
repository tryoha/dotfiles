return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/nvim-nio",
    "nvim-neotest/neotest-python",
    "antoinemadec/FixCursorHold.nvim",
  },
  config = function()
    local neotest = require("neotest")
    neotest.setup({
      adapters = {
        require("neotest-python")({
          runner = "pytest",
        }),
      },
    })

    vim.keymap.set("n", "<leader>tt", function() neotest.run.run(vim.fn.expand("%")) end, { desc = "Run tests in file" })
    vim.keymap.set("n", "<leader>tr", function() neotest.run.run() end, { desc = "Run nearest test" })
    vim.keymap.set("n", "<leader>to", function() neotest.output.open({ enter = true }) end, { desc = "Test output" })
    vim.keymap.set("n", "<leader>ts", function() neotest.summary.toggle() end, { desc = "Test summary" })
  end,
}
