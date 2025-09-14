local opt = vim.opt

-- ========== 基本設定 ==========
-- 行番号を表示
opt.number = true
-- カーソル行からの相対的な行番号を表示する
opt.relativenumber = true
-- カーソルが存在する行にハイライトを当てる
opt.cursorline = true
-- カーソル列にハイライトを当てる（必要に応じてコメントアウト）
-- opt.cursorcolumn = true

-- ========== インデント設定 ==========
-- 新しい行を改行で追加した時に、ひとつ上の行のインデントを引き継がせる
opt.autoindent = true
opt.smartindent = true
-- TABキーを押した時に、2文字分の幅を持ったTABが表示される
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
-- tabstop で設定した数の分の半角スペースが入力される
opt.expandtab = true

-- ========== 検索設定 ==========
-- 検索時に大文字小文字を区別しない
opt.ignorecase = true
-- 検索文字に大文字が含まれる場合は大文字小文字を区別する
opt.smartcase = true
-- 検索結果をハイライト
opt.hlsearch = true
-- リアルタイム検索（入力中に検索結果を表示）
opt.incsearch = true

-- ========== 表示設定 ==========
-- True color サポート
opt.termguicolors = true
-- ファイル名とパスをタイトルバーに表示
opt.title = true
-- 不可視文字を表示
opt.list = true
-- 不可視文字の表示方法を設定
opt.listchars = {
  tab = '→ ',
  trail = '·',
  extends = '»',
  precedes = '«',
  nbsp = '⦸'
}
-- 長い行を折り返す
opt.wrap = true
-- 単語境界で折り返す
opt.linebreak = true
-- 画面端での折り返し時のインデント保持
opt.breakindent = true
-- スクロール時の余白行数
opt.scrolloff = 8
opt.sidescrolloff = 8
-- コマンドラインの高さ
opt.cmdheight = 1

-- ========== 編集設定 ==========
-- Sync with system clipboard
opt.clipboard = 'unnamedplus'
-- アンドゥの永続化
opt.undofile = true
-- バックアップファイルを作成しない
opt.backup = false
opt.writebackup = false
-- スワップファイルを作成しない
opt.swapfile = false
-- 自動保存の設定
opt.updatetime = 300
-- タイムアウト時間の設定
opt.timeoutlen = 500

-- ========== ウィンドウ・分割設定 ==========
-- 新しいウィンドウを下に分割
opt.splitbelow = true
-- 新しいウィンドウを右に分割
opt.splitright = true
-- 分割時にウィンドウサイズを均等にする
opt.equalalways = true

-- ========== 補完設定 ==========
-- コマンドライン補完の改善
opt.wildmenu = true
opt.wildmode = 'longest:full,full'
-- 補完メニューの最大項目数
opt.pumheight = 10
-- 補完時の大文字小文字の扱い
opt.completeopt = 'menu,menuone,noselect'

-- ========== パフォーマンス設定 ==========
-- 描画の更新頻度を上げる
opt.updatetime = 50
-- 構文ハイライトの同期を取る行数を制限（大きなファイルでのパフォーマンス向上）
opt.synmaxcol = 300
-- 画面再描画を遅延させない
opt.lazyredraw = false

-- ========== その他の便利設定 ==========
-- マウスサポート
opt.mouse = 'a'
-- 括弧のマッチングを表示
opt.showmatch = true
-- 括弧マッチングの表示時間（1/10秒単位）
opt.matchtime = 1
-- ファイル変更を自動で読み込み
opt.autoread = true
-- 隠しバッファを許可（保存せずにバッファを切り替え可能）
opt.hidden = true
-- 最後の行の情報を表示
opt.ruler = true
-- ステータスラインを常に表示
opt.laststatus = 2
-- コマンドを画面下部に表示
opt.showcmd = true
-- モード表示を無効化（ステータスラインプラグインを使用する場合）
opt.showmode = false

-- ========== 文字エンコーディング設定 ==========
-- ファイルエンコーディングの自動判別順序
opt.fileencodings = 'utf-8,euc-jp,sjis,cp932,iso-2022-jp'
-- デフォルトのファイルエンコーディング
opt.fileencoding = 'utf-8'

-- ========== 折りたたみ設定 ==========
-- 折りたたみ方法（manual, indent, expr, syntax, diff, marker）
opt.foldmethod = 'indent'
-- 初期状態で折りたたみを無効
opt.foldenable = false
-- 折りたたみレベル
opt.foldlevelstart = 99

-- ========== 問題解決のための設定 ==========
-- 「※」等の記号を打つと、半角文字と重なる問題がある。「※」などを全角文字の幅で表示するために設定する
-- ただし、neotreeの表示が崩れるのでコメントアウト
-- opt.ambiwidth = 'double'

-- CursorHold イベントの発生間隔を短くする（LSP や diagnostics の応答性向上）
vim.opt.updatetime = 300

-- 行の結合時にスペースを自動挿入しない場合がある問題を回避
opt.joinspaces = false