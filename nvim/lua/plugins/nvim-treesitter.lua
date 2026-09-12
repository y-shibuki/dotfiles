local ensure_installed = {
  "bash",
  "c",
  "dockerfile",
  "gitignore",
  "go",
  "gomod",
  "gowork",
  "hcl",
  "javascript",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "python",
  "query",
  "regex",
  "terraform",
  "tmux",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "yaml",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      -- main のパーサー一覧に無いものは自前で登録する（install/update より前に必要）
      vim.api.nvim_create_autocmd("User", {
        pattern = "TSUpdate",
        callback = function()
          require("nvim-treesitter.parsers").tmux = {
            install_info = {
              url = "https://github.com/Freed-Wu/tree-sitter-tmux",
              queries = "queries",
            },
          }
        end,
      })

      require("nvim-treesitter").install(ensure_installed)

      -- ハイライト・インデントを有効にする。パーサー未導入なら自動で入れる
      -- (master の auto_install 相当。main には該当機能が無い)
      local attempted = {}
      local function attach(buf, lang)
        if not vim.api.nvim_buf_is_valid(buf) or not vim.treesitter.language.add(lang) then
          return
        end
        -- クエリとパーサーのバージョン不整合で start が例外を投げることがある
        if not pcall(vim.treesitter.start, buf, lang) then
          return
        end
        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(ev)
          local lang = vim.treesitter.language.get_lang(ev.match)
          if not lang then
            return
          end
          if not vim.treesitter.language.add(lang) then
            if attempted[lang] or not require("nvim-treesitter.parsers")[lang] then
              return
            end
            attempted[lang] = true
            require("nvim-treesitter").install(lang):await(function()
              vim.schedule(function()
                attach(ev.buf, lang)
              end)
            end)
            return
          end
          attach(ev.buf, lang)
        end,
      })
    end,
  },
}
