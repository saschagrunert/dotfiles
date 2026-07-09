return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local ts = require("nvim-treesitter")
      ts.setup()

      local ensure = {
        "bash", "c", "cpp", "css", "dockerfile", "fish",
        "go", "gomod", "gosum", "haskell", "hcl", "html",
        "javascript", "json", "jsonnet", "lua", "make",
        "markdown", "markdown_inline", "nix", "proto", "python",
        "ruby", "rust", "terraform", "toml", "tsx",
        "typescript", "vim", "vimdoc", "yaml",
      }
      local installed = {}
      for _, p in ipairs(ts.get_installed()) do installed[p] = true end
      local to_install = {}
      for _, p in ipairs(ensure) do
        if not installed[p] then table.insert(to_install, p) end
      end
      if #to_install > 0 then pcall(ts.install, to_install) end

      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
  },
}
