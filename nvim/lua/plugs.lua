local Plug = require 'plug'

local opt = vim.opt

Plug.begin('~/.config/nvim/plugged')

Plug('joshdick/onedark.vim', {
  config = function()
    opt.termguicolors = true
    vim.cmd('colorscheme onedark')
  end
})

Plug('ibhagwan/fzf-lua', {
  branch = 'main',
  config = function()
    require'fzf-lua'.setup {
      files = {
        cmd = 'ag --hidden --ignore .git -g ""'
      }
    }
    vim.keymap.set('n', '<c-Space>', ':FzfLua files <Enter>')
  end
})

Plug.ends()
