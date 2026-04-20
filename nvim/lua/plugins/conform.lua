return {
  "stevearc/conform.nvim",
  lazy = vim.g.bootstrap,
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters = {
        -- Laravel Pint (локальный в проекте)
        pint = {
          command = "bash",
          args = { "-lc", "./vendor/bin/pint --quiet $FILENAME" },
          stdin = false,
        },
        -- php-cs-fixer (локальный в проекте)
        php_cs_fixer = {
          command = "bash",
          args = { "-lc", "./vendor/bin/php-cs-fixer fix $FILENAME --quiet" },
          stdin = false,
        },
      },

      formatters_by_ft = {
        -- Web
        javascript = { "prettier" },
        typescript = { "prettier" },
        vue = { "prettier" },
        json = { "prettier" },

        -- PHP: выбери один вариант (ниже порядок приоритета)
        php = { "pint", "php_cs_fixer" },
      },

      format_on_save = {
        timeout_ms = 3000,
        lsp_fallback = true,
      },
    })

    vim.keymap.set({ "n", "v" }, "<leader>f", function()
      conform.format({ timeout_ms = 3000, lsp_fallback = true })
    end, { desc = "Format" })
  end,
}
