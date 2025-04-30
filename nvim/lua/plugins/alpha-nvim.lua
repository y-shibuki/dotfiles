return {
    'goolord/alpha-nvim',
    event = "VimEnter",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        local dashboard = require("alpha.themes.dashboard")

        dashboard.section.buttons.val = {
          dashboard.button("SPC n", " New File", "<cmd>ene <CR>"),
          dashboard.button("SPC e", " Open Explore"),
          dashboard.button("SPC f f", "󰈞 Find File"),
          dashboard.button("SPC s", " Settings", "<cmd>cd ~/.config/nvim<CR> | <cmd>Neotree <CR>"),
          dashboard.button("SPC q", "󰈆 Quit")
        }
        require("alpha").setup(dashboard.opts)
    end
}