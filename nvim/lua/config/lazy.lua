local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.g.bootstrap = vim.env.NVIM_BOOTSTRAP == "1"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  defaults = {
    lazy = vim.g.bootstrap,
  },
})
