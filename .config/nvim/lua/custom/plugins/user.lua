-- Personal settings and keymaps (matching ~/.vimrc)
local opt = vim.opt
local map = vim.keymap.set

-- Default 4-space indentation and column guide at 88
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.colorcolumn = '88'
opt.swapfile = false

-- Save, quit, wrap, and file-tree shortcuts
map('n', '<leader>w', '<cmd>w<CR>', { desc = 'Save file' })
map('n', '<leader>q', '<cmd>q<CR>', { desc = 'Quit' })
map('n', '<leader>z', '<cmd>set wrap!<CR>', { desc = 'Toggle line wrap' })
map('n', '<leader>e', '<cmd>Neotree toggle<CR>', { desc = 'Toggle NeoTree file explorer' })

-- Also keep Space+f+f and Space+f+g as convenient aliases alongside Kickstart's Space+s+f / Space+s+g
map('n', '<leader>ff', function() require('telescope.builtin').find_files() end, { desc = '[F]ind [F]iles' })
map('n', '<leader>fg', function() require('telescope.builtin').live_grep() end, { desc = '[F]ind by [G]rep' })

-- Buffer navigation with Shift+h / Shift+l
map('n', '<S-l>', '<cmd>bnext<CR>', { desc = 'Next buffer' })
map('n', '<S-h>', '<cmd>bprevious<CR>', { desc = 'Previous buffer' })

-- Keep selection after indenting and move selected lines with J/K in visual mode
map('v', '<', '<gv')
map('v', '>', '>gv')
map('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selection down', silent = true })
map('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selection up', silent = true })

-- Keep cursor centered while scrolling and searching
map('n', '<C-d>', '<C-d>zz')
map('n', '<C-u>', '<C-u>zz')
map('n', 'n', 'nzzzv')
map('n', 'N', 'Nzzzv')
