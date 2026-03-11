return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons"
  },

  config = function()

    local function lsp_name()
      local msg = "No LSP"
      local buf_ft = vim.bo.filetype
      local clients = vim.lsp.get_clients()

      for _, client in ipairs(clients) do
        local filetypes = client.config.filetypes
        if filetypes and vim.tbl_contains(filetypes, buf_ft) then
          return client.name
        end
      end

      return msg
    end

    require("lualine").setup({

      options = {
        theme = "auto",
        globalstatus = true,
        section_separators = { left = "", right = "" },
        component_separators = { left = "│", right = "│" },
      },

      sections = {

        lualine_a = { "mode" },

        lualine_b = {
          "branch",
          "diff",
          "diagnostics"
        },

        lualine_c = {
          {
            "filename",
            path = 1
          }
        },

        lualine_x = {
          lsp_name,
          "encoding",
          "filetype"
        },

        lualine_y = {
          "progress"
        },

        lualine_z = {
          "location"
        },
      },
    })
  end,
}
