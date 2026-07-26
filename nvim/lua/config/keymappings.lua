local map = vim.keymap.set

-- Remap space as leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "
map("", "<Space>", "<Nop>", opts)

-- Modes
--   normal_mode = 'n',
--   insert_mode = 'i',
--   visual_mode = 'v',
--   visual_block_mode = 'x',
--   term_mode = 't',
--   command_mode = 'c',

-- Save and quit
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Resize windows
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Select all
map("n", "<C-a>", "gg<S-v>G", { desc = "Select all" })

-- <Space>q で強制終了
map("n", "<leader>q", ":<C-u>q!<Return>", { noremap = true, silent = true, desc = "Quit" })

-- ESC*2 でハイライトやめる
map("n", "<Esc><Esc>", ":<C-u>set nohlsearch<Return>", { desc = "Clear highlights" })

-- Insert --
-- Press jk fast to exit insert mode
map("i", "jk", "<ESC>", { desc = "Exit insert mode" })

-- コンマの後に自動的にスペースを挿入
map("i", ",", ",<Space>", { desc = "Insert space after comma" })

-- rg等を生コマンドで打ちたい時用にターミナルを下分割で開く
-- 結果内は <C-\><C-n> でノーマルモードに入れば / 検索・yank が可能
-- file:line 形式の行は gF でジャンプできる（Vim組み込み機能）
map("n", "<leader>rg", "<cmd>botright split | terminal<cr>i", { desc = "Open terminal (for rg etc.)" })

-- 選択範囲を z レジスタ経由で取得する（unnamed/システムクリップボードを汚さない）
local function get_visual_selection()
  local reg_save = vim.fn.getreg("z")
  local regtype_save = vim.fn.getregtype("z")
  vim.cmd('noautocmd normal! gv"zy')
  local text = vim.fn.getreg("z")
  vim.fn.setreg("z", reg_save, regtype_save)
  return text:gsub("\n", " "):gsub("^%s+", ""):gsub("%s+$", "")
end

-- シェルのシングルクォート内で安全に展開できるようにエスケープする
local function shellescape_single(text)
  return "'" .. text:gsub("'", "'\\''") .. "'"
end

-- visual選択したテキストで rg を打ち込んだ状態でターミナルを開く（実行はせず続けてフラグを追加できる）
map("v", "<leader>rg", function()
  local text = get_visual_selection()
  if text == "" then
    return
  end
  vim.cmd("botright split | terminal")
  vim.cmd("startinsert")
  vim.fn.chansend(vim.b.terminal_job_id, "rg -i " .. shellescape_single(text) .. " ")
end, { desc = "Open terminal with rg prefilled from selection" })