-- Go: 保存時に自動フォーマット（gofumpt）。unused importの削除は行わない
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*.go',
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- Go: import整形は手動実行（<leader>oi）
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'go',
  callback = function(args)
    vim.keymap.set('n', '<leader>oi', function()
      vim.lsp.buf.code_action({
        context = { only = { 'source.organizeImports' } },
        apply = true,
      })
    end, { buffer = args.buf, desc = 'Organize imports (Go)' })
  end,
})
