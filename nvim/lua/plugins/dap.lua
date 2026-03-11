return {
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")

      local python = vim.fn.expand("~/.venvs/nvim-debug/bin/python")
      if python == "" then python = "/usr/bin/python3" end

      dap.adapters.python = {
        type = "executable",
        command = python,
        args = { "-m", "debugpy.adapter" },
      }

      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          pythonPath = function()
            local venv = os.getenv("VIRTUAL_ENV")
            if venv and venv ~= "" then
              return venv .. "/bin/python"
            end
            return python
          end,
        },
      }

      vim.keymap.set("n", "<F5>", dap.continue, { desc = "DAP continue" })
      vim.keymap.set("n", "<F10>", dap.step_over, { desc = "DAP step over" })
      vim.keymap.set("n", "<F11>", dap.step_into, { desc = "DAP step into" })
      vim.keymap.set("n", "<F12>", dap.step_out, { desc = "DAP step out" })
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP breakpoint" })
      vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "DAP REPL" })
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup()

      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

      vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "DAP UI toggle" })
    end,
  },
}
