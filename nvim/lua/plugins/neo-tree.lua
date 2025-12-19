return {
    event = "VimEnter",
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-mini/mini.icons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        window = {
          mappings = {
            ["<space>"] = false,
            ["h"] = "close_node",
            ["l"] = "open",
          }
        },
        source_selector = {
          statusline = true
        },
        -- mini-icon用の設定
        default_component_configs = {
          icon = {
            provider = function(icon, node) -- setup a custom icon provider
              local text, hl
              local mini_icons = require("mini.icons")
              if node.type == "file" then -- if it's a file, set the text/hl
                text, hl = mini_icons.get("file", node.name)
              elseif node.type == "directory" then -- get directory icons
                text, hl = mini_icons.get("directory", node.name)
                -- only set the icon text if it is not expanded
                if node:is_expanded() then
                  text = nil
                end
              end

              if text then
                icon.text = text
              end
              if hl then
                icon.highlight = hl
              end
            end,
          },
          kind_icon = {
            provider = function(icon, node)
              local mini_icons = require("mini.icons")
              icon.text, icon.highlight = mini_icons.get("lsp", node.extra.kind.name)
            end,
          }
        }
      })

      vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<CR>", { desc = "Toggle File Explore" })
    end
}