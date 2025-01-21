---@class Path
---@field name string
---@field ext string|nil
---@field is_dir boolean
---@field is_file boolean
local Path = {}
Path.__index = Path

---@param retFilepath table
---@return Path
function Path:new(retFilepath)
  local obj = setmetatable({}, self)
  obj.name = Path:_retPath(vim.bo.filetype, retFilepath)
  obj.ext = obj.name:match('%.([%w_]+)$')
  obj.is_dir = vim.fn.isdirectory(obj.name) ~= 0
  obj.is_file = vim.fn.filereadable(obj.name) ~= 0
  return obj
end

---@param input string
---@return string
function Path:_replaceEnvVar(input)
  local function retDirOrRawstr(env_var)
    return vim.env[env_var] or ('%' .. env_var .. '%')
  end
  local ret_value = string.gsub(input, '%%(.-)%%', retDirOrRawstr)
  return ret_value
end

---@param filetype string
---@param ret_filepath table
---@return string
function Path:_retPath(filetype, ret_filepath)
  local user_func = ret_filepath[filetype]
  local path

  if user_func then
    path = user_func()
  elseif filetype == 'netrw' then
    local netrw_call = vim.fn['netrw#Call']
    local entry = netrw_call('NetrwGetWord')
    path = netrw_call('NetrwFile', entry)
  else
    local filepath_raw = vim.fn.expand('<cfile>')
    path = Path:_replaceEnvVar(filepath_raw)
  end

  return path
end

return Path
