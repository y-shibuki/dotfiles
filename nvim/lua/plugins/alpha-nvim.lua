return {
  'goolord/alpha-nvim',
  event = "VimEnter",
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local dashboard = require("alpha.themes.dashboard")

    dashboard.section.buttons.val = {
      dashboard.button("SPC n", " New File", "<cmd>ene<CR>"),
      dashboard.button("SPC e", " Open Explore", "<cmd>Neotree toggle<CR>"),
      dashboard.button("SPC f f", "󰈞 Find File", "<cmd>FzfLua files<CR>"),
      dashboard.button("SPC f r", "󰈞 Recent Files", "<cmd>FzfLua oldfiles<CR>"),
      dashboard.button("SPC s", " Settings", "<cmd>cd ~/.config/nvim<CR> | <cmd>Neotree <CR>"),
      dashboard.button("SPC q", "󰈆 Quit", "<cmd>qa<CR>")
    }

    require("alpha").setup(dashboard.opts)
  end
}