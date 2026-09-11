return {
  "Bekaboo/dropbar.nvim",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("dropbar").setup()
    vim.keymap.set("n", "<leader>;", require("dropbar.api").pick, { desc = "Dropbar: Pick" })
  end,
}
