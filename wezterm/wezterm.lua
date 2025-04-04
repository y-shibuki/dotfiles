-- https://wezterm.org/config/lua/general.html
-- References:
--   - https://github.com/QianSong1/wezterm-config
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- # General
config.automatically_reload_config = true 
config.window_close_confirmation = "NeverPrompt"

config.animation_fps = 60
config.max_fps = 60
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"

config.default_domain = 'WSL:Ubuntu'

-- # Appearance
-- ## Cursor
config.default_cursor_style = "BlinkingBlock"
config.cursor_blink_ease_in = 'Constant'
config.cursor_blink_ease_out = 'Constant'
config.cursor_blink_rate = 500

-- ## Scroll Bar
config.scrollback_lines = 1000
config.enable_scroll_bar = true
config.min_scroll_bar_height = "3cell"

-- ## Window Size
config.initial_cols = 160
config.initial_rows = 40
config.window_padding = {
  left = 15,
  right = 15,
  top = 15,
  bottom = 15,
}

-- ## Color
config.color_scheme = 'iceberg-dark'
config.window_background_opacity = 0.85
config.macos_window_background_blur = 20

-- https://github.com/nvim-lualine/lualine.nvim/blob/master/lua/lualine/themes/iceberg_dark.lua
config.colors = {
  tab_bar = {
    inactive_tab_edge = "none",
  },
  scrollbar_thumb = "#eeeeee",
}

-- # Font
config.font = wezterm.font("PlemolJP Console NF", { weight = 'Medium' })
config.font_size = 12
config.line_height = 1.1

-- # Enable IME (For Japanese)
config.use_ime = true

-- # Title Bar
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.integrated_title_button_style = "Windows"
config.integrated_title_button_color = "auto"
config.integrated_title_button_alignment = "Right"

-- Tabs
config.tab_max_width = 20
-- Nightly Only, config.show_close_tab_button_in_tabs = false
config.show_new_tab_button_in_tab_bar = false

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
    local background = "#5c6d74"
    local foreground = "#FFFFFF"
 
    if tab.is_active then
        background = "#ae8b2d"
        foreground = "#FFFFFF"
    end
 
    local title = "   " .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. "   "
 
    return {
        { Background = { Color = background } },
        { Foreground = { Color = foreground } },
        { Text = title },
    }
end)

-- # Key Bindings
local act = wezterm.action
local mod = {}
mod.SUPER = "ALT"
mod.SUPER_REV = "ALT|CTRL"
config.keys = {
  {
    key = 't',
    mods = 'CTRL',
    action = act.SpawnCommandInNewTab {
      domain = { DomainName = 'WSL:Ubuntu' },
      cwd = '~/work'
    },
  },
    -- Copy/Paste --
  { key = "c", mods = "CTRL|SHIFT", action = act.CopyTo("Clipboard") },
  { key = "v", mods = "CTRL|SHIFT", action = act.PasteFrom("Clipboard") },
  -- panes --
  -- panes: split panes
  {
    key = [[/]],
    mods = mod.SUPER_REV,
    action = act.SplitVertical({
      domain = { DomainName = 'WSL:Ubuntu' },
      cwd = '~/work'
    }),
  },
  {
    key = [[\]],
    mods = mod.SUPER_REV,
    action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
  },
  {
    key = [[-]],
    mods = mod.SUPER_REV,
    action = act.CloseCurrentPane({ confirm = true }),
  },

  -- panes: zoom+close pane
  { key = "z", mods = mod.SUPER_REV, action = act.TogglePaneZoomState },
  { key = "w", mods = mod.SUPER, action = act.CloseCurrentPane({ confirm = false }) },

  -- panes: navigation
  { key = "k", mods = mod.SUPER_REV, action = act.ActivatePaneDirection("Up") },
  { key = "j", mods = mod.SUPER_REV, action = act.ActivatePaneDirection("Down") },
  { key = "h", mods = mod.SUPER_REV, action = act.ActivatePaneDirection("Left") },
  { key = "l", mods = mod.SUPER_REV, action = act.ActivatePaneDirection("Right") },

  -- panes: resize
  { key = "UpArrow", mods = mod.SUPER_REV, action = act.AdjustPaneSize({ "Up", 1 }) },
  { key = "DownArrow", mods = mod.SUPER_REV, action = act.AdjustPaneSize({ "Down", 1 }) },
  { key = "LeftArrow", mods = mod.SUPER_REV, action = act.AdjustPaneSize({ "Left", 1 }) },
  { key = "RightArrow", mods = mod.SUPER_REV, action = act.AdjustPaneSize({ "Right", 1 }) },
}

return config