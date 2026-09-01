return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local ok, blink = pcall(require, "blink.cmp")
      local capabilities = ok and blink.get_lsp_capabilities()
        or vim.lsp.protocol.make_client_capabilities()

      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      })

      vim.lsp.config("gopls", {
        settings = {
          gopls = {
            gofumpt = true,
            staticcheck = true,
            analyses = { unusedparams = true, unusedwrite = true, nilness = true },
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
            directoryFilters = { "-vendor" },
          },
        },
      })

      vim.lsp.config("rust_analyzer", {
        settings = {
          ["rust-analyzer"] = {
            checkOnSave = { command = "clippy" },
          },
        },
      })

      vim.lsp.enable({
        "lua_ls", "gopls", "rust_analyzer", "clangd", "pyright",
        "vtsls", "nil_ls", "bashls", "terraformls",
        "yamlls", "jsonls", "taplo",
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
          end
          map("n", "gd", vim.lsp.buf.definition, "Go to definition")
          map("n", "gD", vim.lsp.buf.type_definition, "Type definition")
          map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
          map("n", "<leader>e", vim.diagnostic.open_float, "Diagnostics float")
          map("n", "<leader>ih", function() vim.lsp.inlay_hints.enable(not vim.lsp.inlay_hints.is_enabled({ bufnr = bufnr })) end, "Toggle inlay hints")
          map("n", "gr", function() require("telescope.builtin").lsp_references() end, "References")
        end,
      })

      vim.diagnostic.config({
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "✖",
            [vim.diagnostic.severity.WARN] = "⚠",
            [vim.diagnostic.severity.INFO] = "ℹ",
            [vim.diagnostic.severity.HINT] = "➤",
          },
        },
        virtual_text = false,
        float = { border = "rounded" },
      })
    end,
  },
}
