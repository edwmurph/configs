require 'plugs'

local opt = vim.opt

-- general
vim.g.mapleader = ' '
vim.wo.wrap = false
opt.mouse = 'a'
opt.number = true

-- tab behavior
opt.expandtab = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2

-- mappings spanning multiple modes
vim.keymap.set({ 'v', 'i' }, '<Leader>;', '<Esc>')
vim.keymap.set({ 'n', 'v', 'i' }, '<Leader>;<Leader>', '<Esc> :w <Enter>')

-- normal mode mappings
vim.keymap.set('n', '<Leader>;', '<Esc> :w <Enter>')
vim.keymap.set('n', '<c-@>', ':FZF <Enter>')

-- visual mode mappings
vim.keymap.set('v', '<c-c>', '"*y :let @+=@*<CR>')
