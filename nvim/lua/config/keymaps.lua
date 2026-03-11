local keymap = vim.keymap

-- window navigation
keymap.set("n", "<C-h>", "<C-w>h")
keymap.set("n", "<C-j>", "<C-w>j")
keymap.set("n", "<C-k>", "<C-w>k")
keymap.set("n", "<C-l>", "<C-w>l")

-- file tree
keymap.set("n", "<F3>", ":NvimTreeToggle<CR>")

-- telescope
keymap.set("n", "<leader>ff", ":Telescope find_files<CR>")
keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>")
keymap.set("n", "<leader>fb", ":Telescope buffers<CR>")
keymap.set("n", "<leader>b", "<cmd>Telescope buffers<CR>")

keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>")

keymap.set("n", "<leader>ld", vim.diagnostic.open_float, { desc = "Line diagnostics" })
keymap.set("n", "<leader>lj", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
keymap.set("n", "<leader>lk", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })


-- system copy
keymap.set({ "n", "v" }, "<leader>y", '"+y')
keymap.set("n", "<leader>p", '"+p')

-- переключение вкладок
keymap.set("n", "<S-l>", ":BufferLineCycleNext<CR>")
keymap.set("n", "<S-h>", ":BufferLineCyclePrev<CR>")

-- закрыть вкладку
keymap.set("n", "<leader>bd", ":bd<CR>")
