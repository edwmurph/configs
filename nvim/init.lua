local opt = vim.opt

-- general
vim.g.mapleader = ' '
vim.wo.wrap = false
opt.mouse = 'a'
opt.number = true
opt.clipboard = 'unnamedplus'
vim.g.columns=80
vim.cmd([[set colorcolumn=80]])
vim.cmd([[set title]])
vim.cmd([[set titlestring=%{expand(\"%:p:~\")}]])
vim.cmd([[set statusline=%f\ %l\:%c%=%{&filetype}]])

-- scss
-- vim.cmd([[autocmd FileType scss setl iskeyword+=@-@]])


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
vim.keymap.set('v', '<C-c>', '"+y', { desc = 'Copy selection to clipboard' })
vim.keymap.set('i', '<C-v>', '<C-r>+', { desc = 'Paste from clipboard' })
vim.keymap.set({ 'n', 'v' }, '<C-v>', '"+p', { desc = 'Paste from clipboard' })

require('codex_pane').setup()
require 'plugs'
