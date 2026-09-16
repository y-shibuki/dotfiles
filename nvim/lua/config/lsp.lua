-- LSP configuration
vim.lsp.config('gopls', {
  settings = {
    gopls = {
      gofumpt = true,
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
