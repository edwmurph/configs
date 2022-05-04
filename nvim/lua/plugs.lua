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

Plug('dense-analysis/ale', {
  config = function()
    vim.keymap.set('n', '<Leader>af', ':ALEFix<Enter>')
    vim.keymap.set('n', '<Leader>an', ':ALENext <Enter>')
    vim.keymap.set('n', '<Leader>ap', ':ALEPrevious <Enter>')

    vim.g.ale_lint_on_text_changed = 'never'

    vim.g.ale_fixers = {
      vue = {'eslint'}
    }

    vim.g.ale_linters = {
      javascript = {'eslint'}
    }

    vim.g.ale_pattern_options = {
      -- '.*.json$' = { ale_enabled = 0 },
    }

  end
})

Plug('posva/vim-vue')

Plug.ends()
