return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    -- Load at startup so blink registers its LSP capabilities via
    -- vim.lsp.config("*") before the first language server attaches.
    lazy = false,
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    opts = {
      keymap = {
        preset = "default",
        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      },
      sources = {
        default = { "lsp", "snippets", "path", "buffer" },
      },
      cmdline = {
        sources = function()
          local type = vim.fn.getcmdtype()
          if type == "/" or type == "?" then
            return { "buffer" }
          end
          if type == ":" then
            return { "cmdline", "path" }
          end
          return {}
        end,
      },
      completion = {
        accept = { auto_brackets = { enabled = true } },
        documentation = { auto_show = true },
      },
      signature = { enabled = true },
    },
  },
}
