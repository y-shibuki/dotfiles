return {
  "saghen/blink.cmp",
  lazy = false, -- lazy loading handled internally
  -- use a release tag to download pre-built binaries
  version = "1.*",
  opts = {
    keymap = {
      preset = "enter",
      ["<Tab>"] = { "select_next", "fallback" },
      ["<S-Tab>"] = { "select_prev", "fallback" },
    },

    appearance = {
      -- sets the fallback highlight groups to nvim-cmp's highlight groups
      -- useful for when your theme doesn't support blink.cmp
      -- will be removed in a future release, assuming themes add support
      use_nvim_cmp_as_default = true,
      -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- adjusts spacing and ensures icons are aligned
      nerd_font_variant = "mono",
    },

    -- default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, via `opts_extend`
    sources = {
      default = function()
        local no_buffer_filetypes = {
          go = true,
          python = true,
          java = true,
          lua = true,
          typescript = true,
          typescriptreact = true,
          javascript = true,
          javascriptreact = true,
        }
        if no_buffer_filetypes[vim.bo.filetype] then
          return { "lsp", "path" }
        end
        return { "lsp", "path", "buffer" }
      end,
      -- optionally disable cmdline completions
      -- cmdline = {},
    },

    -- experimental signature help support
    signature = { enabled = true },

    completion = {
      accept = {
        auto_brackets = { enabled = true },
      },
    },
  },
  -- allows extending the providers array elsewhere in your config
  -- without having to redefine it
  opts_extend = { "sources.default" },
}