return {
  -- キーバインドのヘルプを表示
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      icons = {
        breadcrumb = "»",
        separator = "➜",
        group = "+",
      },
      win = {
        border = "rounded",
        padding = { 2, 2, 2, 2 },
        wo = {
          winblend = 0,
        },
      },
      layout = {
        height = { min = 4, max = 30 },
        width = { min = 20, max = 80 },
        spacing = 3,
        align = "left",
      },
      spec = {
        { "<leader>f", group = "Find" },
        { "<leader>g", group = "Git" },
      },
    },
  },
  {
    'echasnovski/mini.icons',
    version = false,
    opts = {
      style = 'glyph',
    },
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        background = {
          light = "latte",
          dark = "mocha",
        },
        transparent_background = true,
        no_italic = true,
        no_bold = false,
        no_underline = false,
        styles = {
          comments = {},
          conditionals = {},
          loops = {},
          functions = {},
          keywords = {},
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
          operators = {},
        },
        integrations = {
          alpha = true,
          blink_cmp = true,
          flash = true,
          gitsigns = true,
          mini = {
            enabled = true,
            indentscope_color = "",
          },
          nvimtree = true,
          treesitter = true,
          fzf = true,
          which_key = true,
        },
      })

      vim.cmd.colorscheme("catppuccin")

      -- fzf-luaと同じく背景を透過させ、エディタ本体との見た目を揃える
      -- which-key.nvim自体がwinhighlightを内部で固定しており、
      -- 実際に使われるハイライトグループ側をNormalにリンクし直すことで上書きする
      -- (WhichKey: キー本体の表示に使われる。catppuccinがNormalFloat=不透明にリンクしているため、
      --  which-key本来のデフォルト(Function、背景なし)に戻して色分けだけ保つ)
      vim.api.nvim_set_hl(0, "WhichKey", { link = "Function" })
      vim.api.nvim_set_hl(0, "WhichKeyNormal", { link = "Normal" })
      vim.api.nvim_set_hl(0, "WhichKeyBorder", { link = "Normal" })
      vim.api.nvim_set_hl(0, "WhichKeyTitle", { link = "Normal" })
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPre", "BufNewFile" },
    main = "ibl",
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      -- hlchunk.nvimの代替として、現在のコードチャンク(スコープ)をハイライトする
      scope = {
        enabled = true,
        show_start = false,
        show_end = false,
      },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
      },
    },
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local autopairs = require("nvim-autopairs")

      autopairs.setup({
        check_ts = true,
        ts_config = {
          lua = { "string", "source" },
          javascript = { "string", "template_string" },
          java = false,
        },
        disable_filetype = { "TelescopePrompt", "spectre_panel" },
        fast_wrap = {
          map = "<M-e>",
          chars = { "{", "[", "(", '"', "'" },
          pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
          offset = 0,
          end_key = "$",
          keys = "qwertyuiopzxcvbnmasdfghjkl",
          check_comma = true,
          highlight = "PmenuSel",
          highlight_grey = "LineNr",
        },
      })
    end,
  },
}
