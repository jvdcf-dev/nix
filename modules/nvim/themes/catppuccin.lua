-- Catppuccin Frappe Green theme using base46
-- See https://nvchad.com/docs/config/theming

local M = {}

M.base_30 = {
  white = "#D9E0EE",
  darker_black = "#191828",
  black = "#1E1D2D", --  nvim bg
  black2 = "#252434",
  one_bg = "#2d2c3c", -- real bg of onedark
  one_bg2 = "#363545",
  one_bg3 = "#3e3d4d",
  grey = "#414559",
  grey_fg = "#4e4d5d",
  grey_fg2 = "#555464",
  light_grey = "#605f6f",
  red = "#F38BA8",
  baby_pink = "#ffa5c3",
  pink = "#F5C2E7",
  line = "#383747", -- for lines like vertsplit
  green = "#ABE9B3",
  vibrant_green = "#b6f4be",
  nord_blue = "#8bc2f0",
  blue = "#89B4FA",
  yellow = "#FAE3B0",
  sun = "#ffe9b6",
  purple = "#d0a9e5",
  dark_purple = "#c7a0dc",
  teal = "#B5E8E0",
  orange = "#F8BD96",
  cyan = "#89DCEB",
  statusline_bg = "#232232",
  lightbg = "#2f2e3e",
  pmenu_bg = "#ABE9B3",
  folder_bg = "#89B4FA",
  lavender = "#c7d1ff",
}

M.base_16 = {
  base00 = "#303446", -- base
  base01 = "#292c3c", -- mantle
  base02 = "#414559", -- surface0
  base03 = "#51576d", -- surface1
  base04 = "#626880", -- surface2
  base05 = "#c6d0f5", -- text
  base06 = "#f2d5cf", -- rosewater
  base07 = "#babbf1", -- lavender
  base08 = "#e78284", -- red
  base09 = "#ef9f76", -- peach
  base0A = "#e5c890", -- yellow
  base0B = "#a6d189", -- green
  base0C = "#81c8be", -- teal
  base0D = "#8caaee", -- blue
  base0E = "#ca9ee6", -- mauve
  base0F = "#eebebe", -- flamingo
}

M.polish_hl = {
  treesitter = {
    ["@variable"] = { fg = M.base_30.lavender },
    ["@property"] = { fg = M.base_30.teal },
    ["@variable.builtin"] = { fg = M.base_30.red },
  },
}

M.type = "white"

return M
