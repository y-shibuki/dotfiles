return {
  'goolord/alpha-nvim',
  event = "VimEnter",
  config = function()
    local dashboard = require("alpha.themes.dashboard")

    -- dashboard.button()はデフォルトでdescを渡さないため、
    -- which-keyでラベルの代わりにコマンド文字列がそのまま表示されてしまう。
    -- keybind_optsに明示的にdescを渡して回避する。
    local function button(sc, label, keybind, desc)
      return dashboard.button(sc, label, keybind, {
        noremap = true,
        silent = true,
        nowait = true,
        desc = desc,
      })
    end

    dashboard.section.buttons.val = {
      button("SPC n", "󰈔  New File", "<cmd>ene<CR>", "New File"),
      button("SPC e", "󰉋  Open Explore", "<cmd>Neotree toggle<CR>", "Open Explore"),
      button("SPC f f", "󰈞  Find File", "<cmd>FzfLua files<CR>", "Find File"),
      button("SPC f r", "󰈞  Recent Files", "<cmd>FzfLua oldfiles<CR>", "Recent Files"),
      button("SPC s", "󰒓  Settings", "<cmd>cd ~/.config/nvim<CR><cmd>Neotree<CR>", "Settings"),
      button("SPC q", "󰈆  Quit", "<cmd>qa<CR>", "Quit"),
    }

    require("alpha").setup(dashboard.opts)
  end
}
