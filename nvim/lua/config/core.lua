local opt = vim.opt
-- 「※」等の記号を打つと、半角文字と重なる問題がある。「※」などを全角文字の幅で表示するために設定する
-- ただし、neotreeの表示が崩れるのでコメントアウト
-- opt.ambiwidth = 'double'

-- 新しい行を改行で追加した時に、ひとつ上の行のインデントを引き継がせる
opt.autoindent = true
opt.smartindent = true
-- カーソルが存在する行にハイライトを当てる
opt.cursorline = true

-- TABキーを押した時に、2文字分の幅を持ったTABが表示される
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
-- tabstop で設定した数の分の半角スペースが入力される
opt.expandtab = true
-- カーソル行からの相対的な行番号を表示する
opt.relativenumber = true
opt.termguicolors = true
-- Sync with system clipboard
opt.clipboard = 'unnamedplus'

opt.termguicolors = true