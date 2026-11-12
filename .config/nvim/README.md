# Jacob's Neovim Configuration

A clean, modern, and personalized Neovim configuration built with native Neovim package management, Treesitter, LSP, and custom workflow plugins.

## Features

- **Package Management:** Native Neovim package manager (`vim.pack`)
- **Theme:** TokyoNight (solid dark background matching Kitty terminal)
- **Fuzzy Finding:** Telescope (`fzf-native`, `ui-select`)
- **Completion & Snippets:** `blink.cmp` + `LuaSnip`
- **LSP & Tooling:** `nvim-lspconfig`, `mason.nvim`, `mason-tool-installer` (Python, Web, Lua, Bash)
- **Formatting:** `conform.nvim` (auto-format on save with `ruff` and `stylua`)
- **File Explorer:** Neo-tree with custom keymaps
- **File Pinning:** Harpoon 2
- **Floating Terminal:** ToggleTerm (`Ctrl+\`)
- **Dashboard:** Custom HyprFrost startup dashboard (`alpha-nvim`)
- **Quality of Life:** `which-key.nvim`, `gitsigns.nvim`, `todo-comments.nvim`, `mini.surround`, `mini.ai`, `mini.statusline`, `indent-blankline`, `autopairs`

## Keymaps

Leader key is `Space`.

### Navigation & Search
- `<leader>sf` or `<leader>ff`: Find files
- `<leader>sg` or `<leader>fg`: Search text across project (live grep)
- `<leader>s.`: Search recent files
- `<leader><leader>`: Search open buffers
- `<leader>sn`: Search Neovim configuration files
- `<leader>sh`: Search help documentation
- `<leader>sk`: Search keymaps
- `Shift+l` / `Shift+h`: Next / previous buffer

### File Explorer & Harpoon
- `<leader>e`: Toggle Neo-tree file sidebar
- `<leader>a`: Add current file to Harpoon
- `<leader>m`: Open Harpoon quick menu
- `<leader>1` .. `<leader>4`: Jump to Harpoon pinned file 1–4

### Editing & Workflow
- `<leader>w`: Save file
- `<leader>q`: Quit
- `<leader>z`: Toggle line wrapping
- `<Ctrl+\>`: Toggle floating terminal
- `J` / `K` (in Visual mode): Move selected lines down / up
- `<` / `>` (in Visual mode): Indent selection and keep visual selection

### LSP Actions (when language server is active)
- `grd`: Go to definition
- `grr`: Go to references
- `gri`: Go to implementation
- `grn`: Rename symbol
- `gra`: Code action
- `K`: Hover documentation
