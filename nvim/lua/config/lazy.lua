require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  defaults = {
    -- プラグインを遅延読み込み
    lazy = false,
    version = false,
  },
  checker = { 
    enabled = true,
    notify = false 
  },
  performance = {
    rtp = {
      -- 不要なプラグインを無効化
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})