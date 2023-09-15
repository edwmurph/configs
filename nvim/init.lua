local opt = vim.opt

-- general
vim.g.mapleader = ' '
vim.wo.wrap = false
opt.mouse = 'a'
opt.number = true
vim.g.columns=80
vim.cmd([[set colorcolumn=80]])
vim.cmd([[set title]])
vim.cmd([[set titlestring=%{expand(\"%:p:~\")}]])
vim.cmd([[set statusline=%f\ %l\:%c%=%{&filetype}]])

-- tab behavior
opt.expandtab = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2

-- mappings spanning multiple modes
vim.keymap.set({ 'v', 'i' }, '<Leader>;', '<Esc>')
vim.keymap.set({ 'v', 'i', 'n' }, '<Leader><Leader>wa', '<Esc>iconst wait = ( ms ) => new Promise( r => setTimeout( r, ms ) );<Esc>')

-- normal mode mappings
vim.keymap.set('n', '<Leader>;', '<Esc> :w <Enter>')
vim.keymap.set('n', '<c-@>', ':FZF <Enter>')

-- visual mode mappings
vim.keymap.set('v', '<c-c>', '"*y :let @+=@*<CR>')

require 'plugs'
