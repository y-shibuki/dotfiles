return {
    -- キーバインドのヘルプを表示
    {
      "folke/which-key.nvim",
      event = "VeryLazy",
      opts = {}
    },
    {
      "catppuccin/nvim",
      name = "catppuccin",
      priority = 1000,
      config = function()
        require("catppuccin").setup({
          transparent_background = true
        })
  
        vim.cmd.colorscheme("catppuccin")
      end
    },
    {
      "lukas-reineke/indent-blankline.nvim",
      main = "ibl",
      ---@module "ibl"
      ---@type ibl.config
      opts = {},
    },
    {
      'windwp/nvim-autopairs',
      event = "InsertEnter",
      config = true,
      opts = {}
    }
}