return {
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local fzf_lua = require("fzf-lua")

    fzf_lua.setup({
      "default-title",
      fzf_opts = {
        ["--no-scrollbar"] = true,
      },
      defaults = {
        formatter = "path.filename_first",
      },
      previewers = {
        builtin = {
          syntax = true,
          syntax_delay = 0,
          syntax_limit_l = 0,
          syntax_limit_b = 1024 * 1024,
          treesitter = { enable = true, disable = {} },
          extensions = {
            ["png"] = { "viu", "-b" },
            ["jpg"] = { "viu", "-b" },
            ["jpeg"] = { "viu", "-b" },
            ["gif"] = { "viu", "-b" },
            ["webp"] = { "viu", "-b" },
          },
        },
      },
      files = {
        cwd_prompt = false,
        actions = {
          ["alt-i"] = { fzf_lua.actions.toggle_ignore },
          ["alt-h"] = { fzf_lua.actions.toggle_hidden },
        },
      },
      git = {
        status = {
          actions = {
            ["right"] = { fzf_lua.actions.git_unstage, fzf_lua.actions.resume },
            ["left"] = { fzf_lua.actions.git_stage, fzf_lua.actions.resume },
          },
        },
      },
      grep = {
        actions = {
          ["alt-i"] = { fzf_lua.actions.toggle_ignore },
          ["alt-h"] = { fzf_lua.actions.toggle_hidden },
        },
      },
    })

    -- Keymaps
    vim.keymap.set("n", "<leader>ff", fzf_lua.files, { desc = "󰈞 Find Files" })
    vim.keymap.set("n", "<leader>fg", fzf_lua.live_grep, { desc = "󰈞 Live Grep" })
    vim.keymap.set("n", "<leader>fb", fzf_lua.buffers, { desc = "󰈞 Find Buffers" })
    vim.keymap.set("n", "<leader>fh", fzf_lua.help_tags, { desc = "󰈞 Help Tags" })
    vim.keymap.set("n", "<leader>fc", fzf_lua.git_commits, { desc = "󰈞 Git Commits" })
    vim.keymap.set("n", "<leader>fs", fzf_lua.git_status, { desc = "󰈞 Git Status" })
    vim.keymap.set("n", "<leader>fr", fzf_lua.oldfiles, { desc = "󰈞 Recent Files" })
    vim.keymap.set("n", "<leader>fw", fzf_lua.grep_cword, { desc = "󰈞 Grep Word" })
    vim.keymap.set("n", "<leader>fW", fzf_lua.grep_cWORD, { desc = "󰈞 Grep WORD" })
    vim.keymap.set("v", "<leader>fw", fzf_lua.grep_visual, { desc = "󰈞 Grep Selection" })
  end,
}