-- Custom HyprFrost / Arch Linux startup dashboard using alpha-nvim
vim.pack.add { 'https://github.com/goolord/alpha-nvim' }

local alpha = require 'alpha'
local dashboard = require 'alpha.themes.dashboard'

-- Gradient colors / highlight groups for header and buttons
vim.api.nvim_set_hl(0, 'DashboardArch', { fg = '#7aa2f7' })
vim.api.nvim_set_hl(0, 'DashboardKey', { fg = '#bb9af7', bold = true })
vim.api.nvim_set_hl(0, 'DashboardDesc', { fg = '#c0caf5' })
vim.api.nvim_set_hl(0, 'DashboardFooter', { fg = '#565f89', italic = true })

dashboard.section.header.val = {
  [[                   -`                   ]],
  [[                  .o+`                  ]],
  [[                 `ooo/                  ]],
  [[                `+oooo:                 ]],
  [[               `+oooooo:                ]],
  [[               -+oooooo+:               ]],
  [[             `/:-:++oooo+:              ]],
  [[            `/++++/+++++++:             ]],
  [[           `/++++++++++++++:            ]],
  [[          `/+++ooooooooooooo/`          ]],
  [[         ./ooosssso++osssssso+`         ]],
  [[        .oossssso-````/ossssss+`        ]],
  [[       -osssssso.      :ssssssso.       ]],
  [[      :osssssss/        osssso+++.      ]],
  [[     /ossssssss/        +ssssooo/-      ]],
  [[   `/ossssso+/:-        -:/+osssso+-    ]],
  [[  `+sso+:-`                 `.-/+oso:   ]],
  [[ `++:.                           `-/+/  ]],
  [[ .`                                 `/  ]],
  [[                                        ]],
  [[   _    _                  ______            _    ]],
  [[  | |  | |                |  ____|          | |   ]],
  [[  | |__| |_   _ _ __  _ __| |__ _ __ ___  ___| |_  ]],
  [[  |  __  | | | | '_ \| '__|  __| '__/ _ \/ __| __| ]],
  [[  | |  | | |_| | |_) | |  | |  | | | (_) \__ \ |_  ]],
  [[  |_|  |_|\__, | .__/|_|  |_|  |_|  \___/|___/\__| ]],
  [[          __/ | |                                 ]],
  [[         |___/|_|                                 ]],
  [[                                                  ]],
  [[               N  E  O  V  I  M                   ]],
}
dashboard.section.header.opts.hl = 'DashboardArch'

-- Clean helper to create beautifully formatted buttons
local function make_button(key, text, action)
  local btn = dashboard.button(key, text, action)
  btn.opts.hl = 'DashboardDesc'
  btn.opts.hl_shortcut = 'DashboardKey'
  btn.opts.width = 44
  btn.opts.cursor = 3
  return btn
end

dashboard.section.buttons.val = {
  make_button('e', '   New File', '<cmd>ene <BAR> startinsert <CR>'),
  make_button('f', '󰈞   Find Files', '<cmd>Telescope find_files<CR>'),
  make_button('g', '󰊄   Live Grep (Search Text)', '<cmd>Telescope live_grep<CR>'),
  make_button('r', '󰋚   Recent Files', '<cmd>Telescope oldfiles<CR>'),
  make_button('h', '󰈡   Harpoon Pinned Files', '<cmd>lua require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())<CR>'),
  make_button('t', '   Toggle Floating Terminal', '<cmd>ToggleTerm<CR>'),
  make_button('c', '   Neovim Configuration', '<cmd>lua require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })<CR>'),
  make_button('q', '󰅚   Quit Neovim', '<cmd>qa<CR>'),
}

-- Dynamic stats footer: shows Neovim version and date
local function stats_footer()
  local v = vim.version()
  local nvim_version = string.format('NVIM v%d.%d.%d', v.major, v.minor, v.patch)
  local date_str = os.date '%Y-%m-%d'
  return string.format('HyprFrost • %s • %s', nvim_version, date_str)
end

dashboard.section.footer.val = stats_footer()
dashboard.section.footer.opts.hl = 'DashboardFooter'

dashboard.opts.layout[1].val = 1 -- Top padding
alpha.setup(dashboard.opts)
