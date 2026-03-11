return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },

    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    -- базовые (как у тебя)
                    "pyright",
                    "lua_ls",
                    "bashls",
                    "jsonls",
                    "ts_ls",

                    -- PHP
                    "intelephense",

                    -- Vue/Volar (Nuxt)
                    "vue_ls",

                    -- optional web
                    "eslint",
                    "html",
                    "cssls",
                    "tailwindcss",
                    "emmet_ls",
                },
            })
        end,
    },

    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
            if ok_cmp then
                capabilities = cmp_lsp.default_capabilities(capabilities)
            end

            local function on_attach(_, bufnr)
                local map = function(mode, lhs, rhs)
                    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true })
                end

                map("n", "gd", vim.lsp.buf.definition)
                map("n", "gr", vim.lsp.buf.references)
                map("n", "K", vim.lsp.buf.hover)
                map("n", "<leader>rn", vim.lsp.buf.rename)
                map("n", "<leader>ca", vim.lsp.buf.code_action)
                map("n", "[d", vim.diagnostic.goto_prev)
                map("n", "]d", vim.diagnostic.goto_next)
                map("n", "<leader>e", vim.diagnostic.open_float)
            end

            -- ====== базовые ======
            vim.lsp.config("pyright", { capabilities = capabilities, on_attach = on_attach })
            vim.lsp.config("ts_ls", { capabilities = capabilities, on_attach = on_attach })
            vim.lsp.config("lua_ls", {
                capabilities = capabilities,
                on_attach = on_attach,
                settings = { Lua = { diagnostics = { globals = { "vim" } } } },
            })
            vim.lsp.config("bashls", { capabilities = capabilities, on_attach = on_attach })
            vim.lsp.config("jsonls", { capabilities = capabilities, on_attach = on_attach })

            -- ====== PHP ======
            vim.lsp.config("intelephense", {
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    intelephense = {
                        files = { maxSize = 5000000 },
                    },
                },
            })

            -- TypeScript (через глобальный npm)
            vim.lsp.config("ts_ls", {
                capabilities = capabilities,
                on_attach = on_attach,
                cmd = { "typescript-language-server", "--stdio" },
            })


            -- ====== Vue / Nuxt ======
            -- В новых конфигурациях vue-language-server идёт как "vue_ls"
            -- и работает в "hybrid mode" вместе с ts_ls. (Подход, который сейчас рекомендуют чаще всего.) :contentReference[oaicite:0]{index=0}
            vim.lsp.config("vue_ls", {
                capabilities = capabilities,
                on_attach = on_attach,
                cmd = { "vue-language-server", "--stdio" },
            })

            -- optional web LSP
            vim.lsp.config("eslint", { capabilities = capabilities, on_attach = on_attach })
            vim.lsp.config("html", { capabilities = capabilities, on_attach = on_attach })
            vim.lsp.config("cssls", { capabilities = capabilities, on_attach = on_attach })
            vim.lsp.config("tailwindcss", { capabilities = capabilities, on_attach = on_attach })
            vim.lsp.config("emmet_ls", {
                capabilities = capabilities,
                on_attach = on_attach,
                filetypes = { "html", "css", "scss", "javascriptreact", "typescriptreact", "vue" },
            })

            vim.lsp.enable({
                "pyright", "ts_ls", "lua_ls", "bashls", "jsonls",
                "intelephense",
                "vue_ls",
                "eslint", "html", "cssls", "tailwindcss", "emmet_ls",
            })
        end,
    },
}
