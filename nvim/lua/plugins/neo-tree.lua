return {
    event = "VimEnter",
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        window = {
          mappings = {
            ["<space>"] = false,
            ["h"] = "close_node",
            ["l"] = "open",
          }
        },
        source_selector = {
          statusline = true
        }
      })

      vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<CR>", { desc = "Toggle File Explore" })
    end
}