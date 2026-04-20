local M = {}

local function trim(text)
  return text:match('^%s*(.-)%s*$')
end

local function has_unescaped_pipe(line)
  local escaped = false

  for i = 1, #line do
    local ch = line:sub(i, i)

    if escaped then
      escaped = false
    elseif ch == '\\' then
      escaped = true
    elseif ch == '|' then
      return true
    end
  end

  return false
end

local function split_unescaped_pipes(line)
  local cells = {}
  local current = {}
  local escaped = false

  for i = 1, #line do
    local ch = line:sub(i, i)

    if escaped then
      current[#current + 1] = ch
      escaped = false
    elseif ch == '\\' then
      current[#current + 1] = ch
      escaped = true
    elseif ch == '|' then
      cells[#cells + 1] = table.concat(current)
      current = {}
    else
      current[#current + 1] = ch
    end
  end

  cells[#cells + 1] = table.concat(current)
  return cells
end

local function parse_row(line)
  if not has_unescaped_pipe(line) then
    return nil
  end

  local indent, content = line:match('^(%s*)(.-)%s*$')
  if not content or content == '' then
    return nil
  end

  local leading_pipe = content:sub(1, 1) == '|'
  local trailing_pipe = content:sub(-1) == '|'
  local cells = split_unescaped_pipes(content)

  if leading_pipe and #cells > 0 then
    table.remove(cells, 1)
  end

  if trailing_pipe and #cells > 0 then
    table.remove(cells, #cells)
  end

  if #cells == 0 then
    return nil
  end

  local parsed = {}
  for i, cell in ipairs(cells) do
    parsed[i] = trim(cell)
  end

  return {
    indent = indent or '',
    cells = parsed,
  }
end

local function parse_alignment(cell)
  local value = trim(cell or '')
  if value == '' then
    return nil
  end

  local left = value:sub(1, 1) == ':'
  local right = value:sub(-1) == ':'
  local body = value

  if left then
    body = body:sub(2)
  end

  if right then
    body = body:sub(1, -2)
  end

  if #body < 3 or not body:match('^%-+$') then
    return nil
  end

  if left and right then
    return 'center'
  end

  if left then
    return 'left'
  end

  if right then
    return 'right'
  end

  return 'default'
end

local function parse_delimiter(cells)
  local alignments = {}

  for i, cell in ipairs(cells) do
    local alignment = parse_alignment(cell)
    if not alignment then
      return nil
    end

    alignments[i] = alignment
  end

  return alignments
end

local function pad_cell(text, width, alignment)
  local value = text or ''
  local length = vim.fn.strdisplaywidth(value)
  local pad = width - length

  if pad <= 0 then
    return value
  end

  if alignment == 'right' then
    return string.rep(' ', pad) .. value
  end

  if alignment == 'center' then
    local left = math.floor(pad / 2)
    local right = pad - left
    return string.rep(' ', left) .. value .. string.rep(' ', right)
  end

  return value .. string.rep(' ', pad)
end

local function delimiter_cell(width, alignment)
  local dash_width = math.max(width, 3)

  if alignment == 'left' then
    return ':' .. string.rep('-', dash_width)
  end

  if alignment == 'right' then
    return string.rep('-', dash_width) .. ':'
  end

  if alignment == 'center' then
    return ':' .. string.rep('-', dash_width) .. ':'
  end

  return string.rep('-', dash_width)
end

local function format_table(rows, alignments)
  local column_count = 0
  for _, row in ipairs(rows) do
    if #row.cells > column_count then
      column_count = #row.cells
    end
  end

  local widths = {}
  for i = 1, column_count do
    widths[i] = 3
  end

  for row_index, row in ipairs(rows) do
    if row_index ~= 2 then
      for col = 1, column_count do
        local cell = row.cells[col] or ''
        local width = vim.fn.strdisplaywidth(cell)
        if width > widths[col] then
          widths[col] = width
        end
      end
    end
  end

  for i = 1, column_count do
    if not alignments[i] then
      alignments[i] = 'default'
    end
  end

  local indent = rows[1].indent or ''
  local formatted = {}

  for row_index, row in ipairs(rows) do
    local cells = {}

    for col = 1, column_count do
      if row_index == 2 then
        cells[col] = delimiter_cell(widths[col], alignments[col])
      else
        cells[col] = pad_cell(row.cells[col] or '', widths[col], alignments[col])
      end
    end

    formatted[#formatted + 1] = indent .. '| ' .. table.concat(cells, ' | ') .. ' |'
  end

  return formatted
end

local function collect_table(lines, start_index)
  local header = parse_row(lines[start_index] or '')
  local delimiter = parse_row(lines[start_index + 1] or '')

  if not header or not delimiter then
    return nil
  end

  if #header.cells ~= #delimiter.cells then
    return nil
  end

  local alignments = parse_delimiter(delimiter.cells)
  if not alignments then
    return nil
  end

  local rows = { header, delimiter }
  local index = start_index + 2

  while index <= #lines do
    local row = parse_row(lines[index])
    if not row then
      break
    end

    rows[#rows + 1] = row
    index = index + 1
  end

  return format_table(rows, alignments), index - 1
end

local function fence_marker(line)
  local marker = line:match('^%s*([`~]+)')
  if marker and #marker >= 3 then
    return marker:sub(1, 1), #marker
  end

  return nil
end

function M.fix(lines)
  local formatted = {}
  local index = 1
  local in_fence = false
  local fence_char = nil
  local fence_len = 0

  while index <= #lines do
    local line = lines[index]
    local marker_char, marker_len = fence_marker(line)

    if in_fence then
      formatted[#formatted + 1] = line

      if marker_char == fence_char and marker_len >= fence_len then
        in_fence = false
      end

      index = index + 1
    elseif marker_char then
      in_fence = true
      fence_char = marker_char
      fence_len = marker_len
      formatted[#formatted + 1] = line
      index = index + 1
    else
      local table_lines, last_index = collect_table(lines, index)

      if table_lines then
        for _, table_line in ipairs(table_lines) do
          formatted[#formatted + 1] = table_line
        end

        index = last_index + 1
      else
        formatted[#formatted + 1] = line
        index = index + 1
      end
    end
  end

  return formatted
end

return M
