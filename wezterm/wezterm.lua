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
-- config.front_end = "WebGpu"
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
config.color_scheme = 'Catppuccin Mocha'
config.window_background_opacity = 0.85
config.macos_window_background_blur = 20

-- # Font
config.font = wezterm.font("PlemolJP Console NF", { weight = 'Medium' })
config.font_size = 13
config.line_height = 1

-- # Enable IME (For Japanese)
config.use_ime = true

-- # Title Bar
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.integrated_title_button_style = "Windows"
config.integrated_title_button_color = "auto"
config.integrated_title_button_alignment = "Right"

-- # Tabs
config.show_tabs_in_tab_bar = false
config.show_new_tab_button_in_tab_bar = false

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
}

return config
