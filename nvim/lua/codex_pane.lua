local M = {}

local state = {
  codex_bufnr = nil,
  codex_winid = nil,
  codex_chan = nil,
  last_source_path = nil,
  visual_refs = {},
  visual_ref_anchor = {},
}

local function abs_path(path)
  if path == nil or path == '' then
    return nil
  end
  return vim.fn.fnamemodify(path, ':p')
end

local function rel_path(path)
  return vim.fn.fnamemodify(path, ':.')
end

local function is_valid_buf(bufnr)
  return bufnr ~= nil and vim.api.nvim_buf_is_valid(bufnr)
end

local function is_valid_win(winid)
  return winid ~= nil and vim.api.nvim_win_is_valid(winid)
end

local function is_file_buffer(bufnr)
  if not is_valid_buf(bufnr) then
    return false
  end

  if vim.bo[bufnr].buftype ~= '' then
    return false
  end

  return vim.api.nvim_buf_get_name(bufnr) ~= ''
end

local function remember_source_context(bufnr)
  if not is_file_buffer(bufnr) then
    return
  end

  local path = abs_path(vim.api.nvim_buf_get_name(bufnr))
  if path ~= nil then
    state.last_source_path = path
  end
end

local function track_current_source_context()
  local bufnr = vim.api.nvim_get_current_buf()
  remember_source_context(bufnr)
end

local function get_terminal_channel(bufnr)
  if not is_valid_buf(bufnr) then
    return nil
  end

  local ok, chan = pcall(vim.api.nvim_buf_get_var, bufnr, 'terminal_job_id')
  if not ok then
    return nil
  end

  return chan
end

local function job_is_running(chan)
  if chan == nil then
    return false
  end

  local ok, result = pcall(vim.fn.jobwait, { chan }, 0)
  if not ok or type(result) ~= 'table' then
    return false
  end

  return result[1] == -1
end

local function codex_job_running()
  if state.codex_chan == nil and is_valid_buf(state.codex_bufnr) then
    state.codex_chan = get_terminal_channel(state.codex_bufnr)
  end
  return job_is_running(state.codex_chan)
end

local function attach_codex_buffer(bufnr)
  state.codex_bufnr = bufnr
  state.codex_chan = get_terminal_channel(bufnr)

  vim.bo[bufnr].buflisted = false

  vim.keymap.set('t', '<C-f>', function()
    M.insert_reference()
  end, {
    buffer = bufnr,
    silent = true,
    desc = 'Insert saved file reference in Codex',
  })

  vim.keymap.set('n', '<C-f>', function()
    M.insert_reference()
  end, {
    buffer = bufnr,
    silent = true,
    desc = 'Insert saved file reference in Codex',
  })
end

local function open_codex_split()
  vim.cmd('rightbelow vsplit')
  state.codex_winid = vim.api.nvim_get_current_win()
end

local function clear_dead_codex_state()
  if not codex_job_running() then
    state.codex_bufnr = nil
    state.codex_winid = nil
    state.codex_chan = nil
  end
end

local function resolve_reference()
  local source_path = state.last_source_path
  if source_path == nil then
    return nil
  end

  local visual_ref = state.visual_refs[source_path]
  if visual_ref ~= nil then
    return visual_ref
  end

  return rel_path(source_path)
end

local function get_buffer_cursor(bufnr)
  local winid = vim.fn.bufwinid(bufnr)
  if winid == -1 then
    return nil
  end

  local ok, cursor = pcall(vim.api.nvim_win_get_cursor, winid)
  if not ok then
    return nil
  end

  return { cursor[1], cursor[2] }
end

local function clear_visual_reference_for_buffer(bufnr)
  if not is_file_buffer(bufnr) then
    return
  end

  local path = abs_path(vim.api.nvim_buf_get_name(bufnr))
  if path == nil then
    return
  end

  local anchor = state.visual_ref_anchor[path]
  if anchor ~= nil then
    local cursor = get_buffer_cursor(bufnr)
    if cursor ~= nil and cursor[1] == anchor[1] and cursor[2] == anchor[2] then
      return
    end
  end

  state.visual_refs[path] = nil
  state.visual_ref_anchor[path] = nil
end

function M.capture_visual_selection(bufnr)
  if not is_file_buffer(bufnr) then
    return
  end

  local path = abs_path(vim.api.nvim_buf_get_name(bufnr))
  if path == nil then
    return
  end

  local mark_start = vim.api.nvim_buf_get_mark(bufnr, '<')
  local mark_end = vim.api.nvim_buf_get_mark(bufnr, '>')
  local start_line = mark_start[1]
  local end_line = mark_end[1]

  if start_line == 0 or end_line == 0 then
    return
  end

  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end

  state.last_source_path = path
  state.visual_refs[path] = string.format('%s:%d-%d', rel_path(path), start_line, end_line)
  state.visual_ref_anchor[path] = get_buffer_cursor(bufnr)
end

function M.insert_reference()
  if not is_valid_buf(state.codex_bufnr) then
    vim.notify('Codex buffer is not available.', vim.log.levels.WARN)
    return
  end

  if not codex_job_running() then
    vim.notify('Codex process is not running.', vim.log.levels.WARN)
    return
  end

  local ref = resolve_reference()
  if ref == nil then
    vim.notify('No source file context available for reference.', vim.log.levels.WARN)
    return
  end

  local winid = state.codex_winid
  if not is_valid_win(winid) then
    winid = vim.fn.bufwinid(state.codex_bufnr)
    if winid == -1 then
      vim.notify('Codex window is not visible.', vim.log.levels.WARN)
      return
    end
    state.codex_winid = winid
  end

  vim.api.nvim_set_current_win(winid)
  local line_count = vim.api.nvim_buf_line_count(state.codex_bufnr)
  local last_line = vim.api.nvim_buf_get_lines(state.codex_bufnr, line_count - 1, line_count, false)[1] or ''
  pcall(vim.api.nvim_win_set_cursor, winid, { line_count, #last_line })
  if vim.fn.mode() ~= 't' then
    vim.cmd('startinsert')
  end

  vim.api.nvim_chan_send(state.codex_chan, '\n\n' .. ref)
end

function M.open_or_focus_codex()
  track_current_source_context()
  clear_dead_codex_state()

  if is_valid_win(state.codex_winid) and is_valid_buf(state.codex_bufnr) then
    vim.api.nvim_set_current_win(state.codex_winid)
    vim.cmd('startinsert')
    return
  end

  if is_valid_buf(state.codex_bufnr) then
    open_codex_split()
    vim.api.nvim_win_set_buf(state.codex_winid, state.codex_bufnr)
    attach_codex_buffer(state.codex_bufnr)
    vim.cmd('startinsert')
    return
  end

  open_codex_split()
  -- Unset NVIM so Codex renders like a regular terminal app.
  vim.cmd('terminal env -u NVIM codex')
  attach_codex_buffer(vim.api.nvim_get_current_buf())
  vim.cmd('startinsert')
end

function M.setup()
  local group = vim.api.nvim_create_augroup('CodexPaneIntegration', { clear = true })

  vim.api.nvim_create_autocmd({ 'BufEnter', 'WinEnter' }, {
    group = group,
    callback = function(args)
      remember_source_context(args.buf)
    end,
  })

  vim.api.nvim_create_autocmd('ModeChanged', {
    group = group,
    callback = function(args)
      local old_mode = vim.v.event.old_mode or ''
      local new_mode = vim.v.event.new_mode or ''
      local left_visual = old_mode:match('^[vV\22]') ~= nil and new_mode:match('^[vV\22]') == nil
      if left_visual then
        M.capture_visual_selection(args.buf)
      end
    end,
  })

  vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
    group = group,
    callback = function(args)
      local mode = vim.fn.mode()
      if mode:match('^[vV\22]') ~= nil then
        return
      end

      clear_visual_reference_for_buffer(args.buf)
    end,
  })

  vim.api.nvim_create_autocmd({ 'TermClose', 'BufWipeout' }, {
    group = group,
    callback = function(args)
      if args.buf == state.codex_bufnr then
        state.codex_winid = nil
        state.codex_bufnr = nil
        state.codex_chan = nil
      end
    end,
  })

  local open_codex = function()
    M.open_or_focus_codex()
  end

  vim.keymap.set('n', '<Leader>cx', open_codex, {
    silent = true,
    desc = 'Open or focus Codex pane',
  })

  vim.keymap.set('v', '<Leader>cx', [[<Esc><Cmd>lua require('codex_pane').open_or_focus_codex()<CR>]], {
    silent = true,
    desc = 'Open or focus Codex pane',
  })

  vim.keymap.set('i', '<Leader>cx', [[<Esc><Cmd>lua require('codex_pane').open_or_focus_codex()<CR>]], {
    silent = true,
    desc = 'Open or focus Codex pane',
  })

  vim.keymap.set('t', '<Leader>cx', [[<C-\><C-n><Cmd>lua require('codex_pane').open_or_focus_codex()<CR>]], {
    silent = true,
    desc = 'Open or focus Codex pane',
  })
end

return M
