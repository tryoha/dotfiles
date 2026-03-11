return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    local ok, configs = pcall(require, "nvim-treesitter.configs")
    if not ok then return end

    configs.setup({
      ensure_installed = {
        "lua", "python", "bash", "json",
        "php",
        "javascript", "typescript", "tsx",
        "vue", "html", "css",
      },
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
}
