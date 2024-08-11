local Plug = require 'plug'

local opt = vim.opt

Plug.begin('~/.config/nvim/plugged')

Plug('joshdick/onedark.vim', {
  config = function()
    opt.termguicolors = true
    vim.cmd('colorscheme onedark')
  end
})

Plug('hashivim/vim-terraform', {
  config = function()
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
      javascript = {'eslint'},
      javascriptreact = {'eslint'},
      typescript = {'eslint', 'prettier'},
      vue = {'eslint'}
    }

    vim.g.ale_linters = {
      javascript = {'eslint'},
      javascriptreact = {'eslint'},
      typescript = {'eslint', 'prettier'}
    }

    vim.g.ale_pattern_options = {
      -- '.*.json$' = { ale_enabled = 0 },
    }

  end
})

Plug('neoclide/coc.nvim', {
  branch = 'release',
  config = function()
    vim.g.coc_global_extensions = {'coc-tsserver', 'coc-json', 'coc-html', 'coc-css'}
    vim.opt.updatetime = 300
    vim.opt.signcolumn = "yes"
    vim.api.nvim_set_keymap('i', '<CR>', 'pumvisible() ? coc#_select_confirm() : "\\<C-g>u\\<CR>\\<c-r>=coc#on_enter()\\<CR>"', { noremap = true, expr = true, silent = true })
  end
})

Plug('yaegassy/coc-volar', {
  run = 'yarn install --frozen-lockfile',
})

Plug('yaegassy/coc-volar-tools', {
  run = 'yarn install --frozen-lockfile'
})

-- Plug('ms-jpq/coq_nvim', {
--   branch = 'coq',
--   config = function()
--     vim.g.coq_settings = {
--       auto_start = 'shut-up'
--     }
-- 
--   end
-- })
-- 
-- Plug('ms-jpq/coq.artifacts', {
--   branch = 'artifacts'
-- })

Plug('sheerun/vim-polyglot')

Plug('posva/vim-vue')

Plug('tpope/vim-fugitive')

Plug('github/copilot.vim', {
  config = function()
    vim.keymap.set('i', '<c-]>', '<Plug>(copilot-next)')
    vim.keymap.set('i', '<c-[>', '<Plug>(copilot-previous)')
    vim.g.copilot_node_command = "~/Library/Caches/fnm_multishells/94543_1694733076205/bin/node"
  end
})

Plug.ends()
