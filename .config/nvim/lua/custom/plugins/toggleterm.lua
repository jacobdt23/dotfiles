-- Floating terminal inside Neovim: press Ctrl+\ to toggle open/closed
vim.pack.add { 'https://github.com/akinsho/toggleterm.nvim' }

require('toggleterm').setup {
  open_mapping = [[<c-\>]],
  direction = 'float',
  float_opts = {
    border = 'rounded',
  },
}
