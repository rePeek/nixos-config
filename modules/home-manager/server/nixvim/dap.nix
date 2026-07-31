{
  plugins.dap = {
    enable = true;

    adapters = {
      executables = {
        codelldb = {
          command = "codelldb";
        };
      };
    };

    configurations = {
      cpp = [
        {
          name = "C/C++: Launch file";
          type = "codelldb";
          request = "launch";
          program = "\${fileDirname}/\${fileBasenameNoExtension}";
          cwd = "\${workspaceFolder}";
          stopOnEntry = false;
        }
      ];
      rust = [
        {
          name = "Rust: Launch file";
          type = "codelldb";
          request = "launch";
          program = "\${fileDirname}/\${fileBasenameNoExtension}";
          cwd = "\${workspaceFolder}";
          stopOnEntry = false;
        }
      ];
      python = [
        {
          name = "Python: Launch file";
          type = "codelldb";
          request = "launch";
          program = "\${file}";
          cwd = "\${workspaceFolder}";
          stopOnEntry = false;
        }
      ];
    };
  };

  plugins.dap-ui = {
    enable = true;
  };

  # ── DAP Keymaps ──
  keymaps = [
    {
      key = "<leader>db";
      mode = "n";
      action = {
        __raw = "function() require('dap').toggle_breakpoint() end";
      };
      options = {
        desc = "Toggle breakpoint";
      };
    }
    {
      key = "<leader>dc";
      mode = "n";
      action = {
        __raw = "function() require('dap').continue() end";
      };
      options = {
        desc = "Continue";
      };
    }
    {
      key = "<leader>dn";
      mode = "n";
      action = {
        __raw = "function() require('dap').step_over() end";
      };
      options = {
        desc = "Step over";
      };
    }
    {
      key = "<leader>ds";
      mode = "n";
      action = {
        __raw = "function() require('dap').step_into() end";
      };
      options = {
        desc = "Step into";
      };
    }
    {
      key = "<leader>do";
      mode = "n";
      action = {
        __raw = "function() require('dap').step_out() end";
      };
      options = {
        desc = "Step out";
      };
    }
    {
      key = "<leader>dr";
      mode = "n";
      action = {
        __raw = "function() require('dap').restart() end";
      };
      options = {
        desc = "Restart";
      };
    }
    {
      key = "<leader>dt";
      mode = "n";
      action = {
        __raw = "function() require('dap').terminate() end";
      };
      options = {
        desc = "Terminate";
      };
    }
    {
      key = "<leader>du";
      mode = "n";
      action = {
        __raw = "function() require('dapui').toggle() end";
      };
      options = {
        desc = "Toggle DAP UI";
      };
    }
  ];

  # ── Auto-open DAP UI on debug start ──
  extraConfigLua = ''
    local dap, dapui = require("dap"), require("dapui")
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end
  '';
}
