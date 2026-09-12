return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  event = "VeryLazy",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("nvim-treesitter-textobjects").setup({
      select = { lookahead = true },
      move = { set_jumps = true },
    })

    local select = require("nvim-treesitter-textobjects.select")
    for key, obj in pairs({
      aa = "@parameter.outer",
      ia = "@parameter.inner",
      af = "@function.outer",
      ["if"] = "@function.inner",
      ac = "@class.outer",
      ic = "@class.inner",
    }) do
      vim.keymap.set({ "x", "o" }, key, function()
        select.select_textobject(obj, "textobjects")
      end, { desc = "Textobject " .. obj })
    end

    local move = require("nvim-treesitter-textobjects.move")
    for key, spec in pairs({
      ["]m"] = { "goto_next_start", "@function.outer" },
      ["]]"] = { "goto_next_start", "@class.outer" },
      ["]M"] = { "goto_next_end", "@function.outer" },
      ["]["] = { "goto_next_end", "@class.outer" },
      ["[m"] = { "goto_previous_start", "@function.outer" },
      ["[["] = { "goto_previous_start", "@class.outer" },
      ["[M"] = { "goto_previous_end", "@function.outer" },
      ["[]"] = { "goto_previous_end", "@class.outer" },
    }) do
      vim.keymap.set({ "n", "x", "o" }, key, function()
        move[spec[1]](spec[2], "textobjects")
      end, { desc = "Move " .. spec[2] })
    end
  end,
}
