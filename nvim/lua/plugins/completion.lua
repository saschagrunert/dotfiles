return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    opts = {
      keymap = {
        preset = "default",
        ["<C-b>"] = { "scroll_documentation_up" },
        ["<C-f>"] = { "scroll_documentation_down" },
        ["<C-Space>"] = { "show" },
        ["<C-e>"] = { "cancel" },
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
      snippets = { preset = "default" },
    },
  },
}
