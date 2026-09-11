return {
  "sindrets/diffview.nvim",
  cmd = {
    "DiffviewOpen",
    "DiffviewClose",
    "DiffviewToggleFiles",
    "DiffviewFocusFiles",
    "DiffviewRefresh",
    "DiffviewFileHistory",
  },
  keys = {
    { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview: Open" },
    { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview: Current File History" },
    { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Diffview: Repo History" },
  },
  opts = {
    -- mini.iconsのみを使う構成のため、未導入のnvim-web-devicons依存を避ける
    use_icons = false,
  },
}
