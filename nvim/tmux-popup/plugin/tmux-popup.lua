-- Step 3: deliver text to a chosen tmux pane
local function pick_pane_and_send(text)
  local raw = vim.fn.system(
    "tmux list-panes -a -F '#{session_name}:#{window_index}.#{pane_index}  [#{pane_current_command}]  #{pane_current_path}'"
  )
  local panes = vim.split(vim.trim(raw), "\n", { plain = true })
  if #panes == 0 or (panes[1] == "") then
    vim.notify("tmux-popup: no panes found", vim.log.levels.WARN)
    return
  end

  vim.ui.select(panes, { prompt = "Send to pane" }, function(selected)
    if not selected then
      return
    end
    local target = selected:match("^(%S+)")
    vim.fn.system({ "tmux", "send-keys", "-t", target, "-l", text })
  end)
end

-- Step 2: show a floating editor with the formatted content; <C-s> triggers step 3
local function open_float(content)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].bufhidden = "wipe"
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(content, "\n", { plain = true }))
  -- markdown filetype so treesitter injects the fenced language's highlighting
  vim.bo[buf].filetype = "markdown"

  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.5)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    width = width,
    height = height,
    border = "rounded",
    title = " Edit & Send  <C-s> ",
    title_pos = "center",
    style = "minimal",
  })
  vim.wo[win].wrap = true

  local function send()
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    vim.api.nvim_win_close(win, true)
    pick_pane_and_send(table.concat(lines, "\n"))
  end

  local function cancel()
    vim.api.nvim_win_close(win, true)
  end

  vim.keymap.set({ "n", "i" }, "<C-s>", send, { buffer = buf, nowait = true })
  vim.keymap.set("n", "q", cancel, { buffer = buf, nowait = true })
  vim.keymap.set("n", "<Esc>", cancel, { buffer = buf, nowait = true })

  -- land cursor inside the code fence, not on the header
  vim.api.nvim_win_set_cursor(win, { 4, 0 })
end

-- Step 1: capture the live visual selection, build a markdown code block, open the float
vim.keymap.set("v", "<leader>ts", function()
  local start_pos = vim.fn.getpos("v")
  local end_pos = vim.fn.getpos(".")
  local start_line, start_col = start_pos[2], start_pos[3]
  local end_line, end_col = end_pos[2], end_pos[3]
  if start_line > end_line or (start_line == end_line and start_col > end_col) then
    start_line, start_col, end_line, end_col = end_line, end_col, start_line, start_col
  end

  local buf_lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  if #buf_lines == 0 then
    return
  end

  buf_lines[#buf_lines] = buf_lines[#buf_lines]:sub(1, end_col)
  buf_lines[1] = buf_lines[1]:sub(start_col)

  -- build a repo-relative @file:line header so Claude Code gets a usable reference
  local src_ft = vim.bo[0].filetype
  local git_root = vim.trim(vim.fn.system("git rev-parse --show-toplevel"))
  local abs_path = vim.fn.expand("%:p")
  local rel_path = abs_path:sub(#git_root + 2)
  local header = "@" .. rel_path .. ":" .. start_line

  local content = header .. "\n\n```" .. src_ft .. "\n" .. table.concat(buf_lines, "\n") .. "\n```"
  open_float(content)
end, { desc = "Send selection to tmux pane" })
