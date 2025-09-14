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
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })

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

-- New tab
map("n", "te", ":tabedit", { desc = "New tab" })
-- move tab
map("n", "gh", "gT", { desc = "Move tab left" })
map("n", "gl", "gt", { desc = "Move tab right" })

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