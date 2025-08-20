local M = {}

local preview_bufnr = nil
local preview_winnr = nil
local current_puml_file = nil
local job_id = nil

local function compile_plantuml(filepath, callback)
  if job_id then
    vim.fn.jobstop(job_id)
  end
  
  local png_path = filepath:gsub("%.puml$", ".png")
  local cmd = string.format("java -jar ~/src/plantuml.jar %s 2>/dev/null", vim.fn.shellescape(filepath))
  
  job_id = vim.fn.jobstart(cmd, {
    on_exit = function(_, exit_code)
      job_id = nil
      if exit_code == 0 then
        if callback then
          vim.schedule(function()
            callback(png_path)
          end)
        end
      else
        vim.schedule(function()
          vim.notify("PlantUML compilation failed", vim.log.levels.ERROR)
        end)
      end
    end,
    on_stderr = function(_, data)
      if data and #data > 0 and data[1] ~= "" then
        vim.schedule(function()
          vim.notify("PlantUML: " .. table.concat(data, "\n"), vim.log.levels.WARN)
        end)
      end
    end,
    stdout_buffered = false,
    stderr_buffered = false,
  })
end

local function open_preview_window(png_path)
  local current_win = vim.api.nvim_get_current_win()
  
  if preview_winnr and vim.api.nvim_win_is_valid(preview_winnr) then
    vim.api.nvim_set_current_win(preview_winnr)
  else
    vim.cmd('vsplit')
    preview_winnr = vim.api.nvim_get_current_win()
  end
  
  if preview_bufnr and vim.api.nvim_buf_is_valid(preview_bufnr) then
    vim.api.nvim_win_set_buf(preview_winnr, preview_bufnr)
  else
    preview_bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(preview_winnr, preview_bufnr)
    vim.api.nvim_buf_set_option(preview_bufnr, 'buftype', 'nofile')
    vim.api.nvim_buf_set_option(preview_bufnr, 'bufhidden', 'hide')
    vim.api.nvim_buf_set_option(preview_bufnr, 'swapfile', false)
  end
  
  vim.cmd('edit ' .. vim.fn.fnameescape(png_path))
  
  vim.api.nvim_set_current_win(current_win)
end

local function refresh_preview()
  if current_puml_file then
    -- Silent recompile without notification
    compile_plantuml(current_puml_file, function(png_path)
      if preview_winnr and vim.api.nvim_win_is_valid(preview_winnr) then
        local current_win = vim.api.nvim_get_current_win()
        vim.api.nvim_set_current_win(preview_winnr)
        vim.cmd('edit! ' .. vim.fn.fnameescape(png_path))
        vim.api.nvim_set_current_win(current_win)
      end
    end)
  end
end

function M.toggle_preview()
  local filepath = vim.api.nvim_buf_get_name(0)
  
  if not filepath:match("%.puml$") then
    vim.notify("Not a PlantUML file", vim.log.levels.WARN)
    return
  end
  
  -- Store the absolute path
  current_puml_file = vim.fn.fnamemodify(filepath, ":p")
  
  compile_plantuml(current_puml_file, open_preview_window)
end

function M.setup()
  vim.api.nvim_create_autocmd({"BufWritePost"}, {
    pattern = "*.puml",
    callback = function(args)
      -- Get the absolute path of the saved file
      local saved_file = vim.fn.fnamemodify(args.file, ":p")
      local tracked_file = current_puml_file and vim.fn.fnamemodify(current_puml_file, ":p") or ""
      
      -- Debug: show what files we're comparing
      -- vim.notify(string.format("Checking - Saved: %s, Tracking: %s", saved_file, tracked_file), vim.log.levels.INFO)
      
      if saved_file == tracked_file and preview_winnr and vim.api.nvim_win_is_valid(preview_winnr) then
        refresh_preview()
      end
    end,
    group = vim.api.nvim_create_augroup("PlantUMLPreview", { clear = true })
  })
  
  vim.api.nvim_create_autocmd({"WinClosed"}, {
    callback = function()
      if preview_winnr and not vim.api.nvim_win_is_valid(preview_winnr) then
        preview_winnr = nil
        preview_bufnr = nil
        current_puml_file = nil
      end
    end,
    group = vim.api.nvim_create_augroup("PlantUMLPreviewCleanup", { clear = true })
  })
end

return M