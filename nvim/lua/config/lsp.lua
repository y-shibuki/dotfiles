-- LSP configuration
vim.lsp.config('gopls', {
  settings = {
    gopls = {
      gofumpt = true,
      usePlaceholders = true,
      completeUnimported = true,
      matcher = 'Fuzzy',
      staticcheck = true,
      analyses = {
        unusedparams = true,
        shadow = true,
        nilness = true,
      },
      hints = {
        assignVariableTypes = true,
        parameterNames = true,
        compositeLiteralFields = true,
      },
    },
  },
})

vim.lsp.enable({
  'pyright',      -- Python
  'jdtls',        -- Java
  'lua_ls',       -- Lua
  'dockerls',     -- Docker
  'ts_ls',        -- TypeScript/JavaScript
  'bashls',       -- Bash
  'gopls',        -- Go
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client:supports_method('textDocument/inlayHint') then
      vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
    end
  end,
})
