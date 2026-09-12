return {
  "ibhagwan/fzf-lua",
  ---@module "fzf-lua"
  ---@type fzf-lua.Config|{}
  ---@diagnostics disable: missing-fields
  dependencies = { "nvim-mini/mini.icons" },
  cmd = "FzfLua",
  keys = {
    { "<leader>fq", desc = "󰈞 Ghq Repos (new tab)" },
    { "<leader>ff", desc = "󰈞 Find Files" },
    { "<leader>fg", desc = "󰈞 Live Grep" },
    { "<leader>fb", desc = "󰈞 Find Buffers" },
    { "<leader>fh", desc = "󰈞 Help Tags" },
    { "<leader>gc", desc = "󰈞 Git Commits" },
    { "<leader>gs", desc = "󰈞 Git Status" },
    { "<leader>fr", desc = "󰈞 Recent Files" },
    { "<leader>fw", desc = "󰈞 Grep Word" },
    { "<leader>fW", desc = "󰈞 Grep WORD" },
    { "<leader>fw", mode = "v", desc = "󰈞 Grep Selection" },
    { "<leader>fk", desc = "󰈞 Keymaps" },
    { "<leader>fC", desc = "󰈞 Commands" },
  },
  config = function()
    local fzf_lua = require("fzf-lua")

    fzf_lua.setup({
      defaults = {
        formatter = "path.filename_first",
      },
      hls = {
        normal = "Normal",
        border = "Normal",
        preview_normal = "Normal",
        preview_border = "Normal",
      },
      previewers = {
        builtin = {
          syntax = true,
          syntax_delay = 0,
          syntax_limit_l = 0,
          syntax_limit_b = 1024 * 1024,
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

    -- ghqで管理しているリポジトリをファジー検索し、新しいタブで開く
    local function ghq_open_in_tab()
      local root = vim.fn.system("ghq root"):gsub("\n", "")

      fzf_lua.fzf_exec("ghq list", {
        prompt = "Ghq Repos> ",
        actions = {
          ["default"] = function(selected)
            if not selected or #selected == 0 then
              return
            end
            local path = root .. "/" .. selected[1]
            vim.cmd("tabnew")
            vim.cmd("tcd " .. vim.fn.fnameescape(path))
            require("neo-tree.command").execute({ action = "show", dir = path })
          end,
        },
      })
    end

    -- Keymaps
    vim.keymap.set("n", "<leader>fq", ghq_open_in_tab, { desc = "󰈞 Ghq Repos (new tab)" })
    vim.keymap.set("n", "<leader>ff", fzf_lua.files, { desc = "󰈞 Find Files" })
    vim.keymap.set("n", "<leader>fg", fzf_lua.live_grep, { desc = "󰈞 Live Grep" })
    vim.keymap.set("n", "<leader>fb", fzf_lua.buffers, { desc = "󰈞 Find Buffers" })
    vim.keymap.set("n", "<leader>fh", fzf_lua.help_tags, { desc = "󰈞 Help Tags" })
    vim.keymap.set("n", "<leader>gc", fzf_lua.git_commits, { desc = "󰈞 Git Commits" })
    vim.keymap.set("n", "<leader>gs", fzf_lua.git_status, { desc = "󰈞 Git Status" })
    vim.keymap.set("n", "<leader>fr", fzf_lua.oldfiles, { desc = "󰈞 Recent Files" })
    vim.keymap.set("n", "<leader>fw", fzf_lua.grep_cword, { desc = "󰈞 Grep Word" })
    vim.keymap.set("n", "<leader>fW", fzf_lua.grep_cWORD, { desc = "󰈞 Grep WORD" })
    vim.keymap.set("v", "<leader>fw", fzf_lua.grep_visual, { desc = "󰈞 Grep Selection" })
    vim.keymap.set("n", "<leader>fk", fzf_lua.keymaps, { desc = "󰈞 Keymaps" })
    vim.keymap.set("n", "<leader>fC", fzf_lua.commands, { desc = "󰈞 Commands" })
  end,
  ---@diagnostics enable: missing-fields
}