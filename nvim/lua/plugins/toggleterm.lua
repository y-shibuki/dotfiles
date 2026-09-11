return {
  "akinsho/toggleterm.nvim",
  version = "*",
  cmd = { "ToggleTerm", "TermExec" },
  keys = {
    { "<C-\\>", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal", mode = { "n", "t" } },
  },
  opts = {
    direction = "float",
    float_opts = {
      border = "rounded",
    },
    open_mapping = false, -- keysで代わりに定義
    close_on_exit = true,
    start_in_insert = true,
  },
}
