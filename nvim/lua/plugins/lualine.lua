return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "dracula",
        component_separators = { left = "\u{e0b1}", right = "\u{e0b3}" },
        section_separators = { left = "\u{e0b0}", right = "\u{e0b2}" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },
        -- Encoding and line endings only when they differ from utf-8 and unix
        lualine_x = {
          {
            "encoding",
            cond = function()
              return vim.bo.fileencoding ~= "" and vim.bo.fileencoding ~= "utf-8"
            end,
          },
          {
            "fileformat",
            cond = function()
              return vim.bo.fileformat ~= "unix"
            end,
          },
          "filetype",
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },
}
