---@class CustomModule
local M = {}

---@param input string
---@return string
function M.replace_env_var(input)
  local function ret_dir_or_raw_str(env_var)
    return vim.env[env_var] or ('%' .. env_var .. '%')
  end
  local ret_value = string.gsub(input, '%%(.-)%%', ret_dir_or_raw_str)
  return ret_value
end

---@param prog_exts table
---@return table
function M.create_association_table(prog_exts)
  local association_table = {}
  for prog, exts in pairs(prog_exts) do
    for _, ext in ipairs(exts) do
      local prog_env = M.replace_env_var(prog)
      association_table[ext] = prog_env
    end
  end

  return association_table
end

---@param filetype string
---@param ret_filepath table
---@return string
function M.get_filepath(filetype, ret_filepath)
  local func = ret_filepath[filetype]
  local filepath

  if func then
    filepath = func()
  elseif filetype == 'netrw' then
    local netrw_call = vim.fn['netrw#Call']
    local entry = netrw_call('NetrwGetWord')
    filepath = netrw_call('NetrwFile', entry)
  else
    local filepath_raw = vim.fn.expand('<cfile>')
    filepath = M.replace_env_var(filepath_raw)
  end

  return filepath
end

return M
