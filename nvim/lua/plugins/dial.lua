return {
  "monaqa/dial.nvim",
  keys = {
    { "<C-a>", function() require("dial.map").manipulate("increment", "normal") end, mode = "n" },
    { "<C-x>", function() require("dial.map").manipulate("decrement", "normal") end, mode = "n" },
    { "<C-a>", function() require("dial.map").manipulate("increment", "visual") end, mode = "v" },
    { "<C-x>", function() require("dial.map").manipulate("decrement", "visual") end, mode = "v" },
    { "g<C-a>", function() require("dial.map").manipulate("increment", "gvisual") end, mode = "v" },
    { "g<C-x>", function() require("dial.map").manipulate("decrement", "gvisual") end, mode = "v" },
  },
  config = function()
    local augend = require("dial.augend")

    local default_augends = {
      augend.integer.alias.decimal,                                                        -- 10進数
      augend.date.alias["%Y/%m/%d"],                                                        -- 日付 2024/01/01
      augend.date.alias["%Y-%m-%d"],                                                        -- 日付 2024-01-01
      augend.date.alias["%m/%d"],                                                           -- 日付 01/01
      augend.date.alias["%H:%M:%S"],                                                        -- 時刻 01:02:03
      augend.date.alias["%H:%M"],                                                           -- 時刻 01:02
      augend.constant.alias.alpha,                                                          -- アルファベット a → b → c
      augend.constant.new({ elements = { "true", "false" }, word = true, cyclic = true }),  -- true/false
      augend.constant.new({ elements = { "True", "False" }, word = true, cyclic = true }),  -- Python風 True/False
      augend.constant.new({ elements = { "TRUE", "FALSE" }, word = true, cyclic = true }),  -- 全大文字 TRUE/FALSE
      augend.constant.new({ elements = { "and", "or" }, word = true, cyclic = true }),      -- and/or
      augend.constant.new({ elements = { "&&", "||" }, word = false, cyclic = true }),       -- 論理演算子
      augend.constant.new({ elements = { "==", "!=" }, word = false, cyclic = true }),       -- 比較演算子
      augend.constant.new({ elements = { "yes", "no" }, word = true, cyclic = true }),       -- yes/no
      augend.constant.new({ elements = { "on", "off" }, word = true, cyclic = true }),       -- on/off
      augend.constant.new({ elements = { "enable", "disable" }, word = true, cyclic = true }), -- enable/disable
      augend.constant.new({ elements = { "min", "max" }, word = true, cyclic = true }),      -- min/max
      augend.constant.new({ elements = { "asc", "desc" }, word = true, cyclic = true }),     -- asc/desc
      augend.constant.new({
        elements = { "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" },
        word = true,
        cyclic = true,
      }), -- 曜日 (フル表記)
      augend.constant.new({
        elements = { "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" },
        word = true,
        cyclic = true,
      }), -- 曜日 (省略表記)
      augend.constant.new({
        elements = {
          "January", "February", "March", "April", "May", "June",
          "July", "August", "September", "October", "November", "December",
        },
        word = true,
        cyclic = true,
      }), -- 月名
      augend.constant.new({ elements = { "GET", "POST", "PUT", "PATCH", "DELETE" }, word = true, cyclic = true }), -- HTTPメソッド
    }

    require("dial.config").augends:register_group({ default = default_augends })

    require("dial.config").augends:on_filetype({
      markdown = vim.list_extend(vim.deepcopy(default_augends), {
        augend.constant.new({ elements = { "[ ]", "[x]" }, word = false, cyclic = true }), -- Markdownチェックボックス
      }),
    })
  end,
}
