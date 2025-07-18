local wezterm = require 'wezterm'

config = wezterm.config_builder()

config = {
    default_prog = { 'bash','-l','-c','clear; exec bash' },
    automatically_reload_config = true,
    enable_tab_bar = false,
    scrollback_lines = 10000,
    window_close_confirmation = 'NeverPrompt',
    color_scheme = 'Nebula (base16)',
    default_cursor_style = 'BlinkingBar',
    max_fps = 120,
    prefer_egl = true,
    font = wezterm.font_with_fallback({
        'JetBrainsMono Nerd Font',
        'JetBrains Mono Nerd Font',
        'JetBrainsMono NF',
        'Noto Sans Mono Nerd Font',
        'Noto Mono Nerd Font',
        'JetBrains Mono',
        'Noto Sans Mono',
    }),
    -- window_decorations = 'RESIZE',
    hide_tab_bar_if_only_one_tab = true,
    font_size = 12.0,
    background = {
        { 
            source = {
                File = '/home/Lexnaid/personal/Pictures/original-wallpaper.jpg',
            },
            hsb = {
                hue = 1.0,
                saturation = 1.02,
                brightness = 0.25,
            },
            width = '100%',
            height = '100%',
        },
        {
            source = {
                Color = '#20142b',
            },
            width = '100%',
            height = '100%',
            opacity = 0.85,
        },
    },
    window_padding = {
        left = 3,
        right = 3,
        top = 0,
        bottom = 0,
    },
}

return config
  
