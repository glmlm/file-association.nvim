---@class Path
---@field name string
local Path = {}
Path.__index = Path

---@param retFilepath table
---@return Path
function Path:new(retFilepath)
  local obj = setmetatable({}, self)
  obj.name = Path:_retPath(vim.bo.filetype, retFilepath)
  return obj
end

---@return string|nil
function Path:getExtension()
  return self.name:match('%.([%w_]+)$')
end

---@return boolean
function Path:isDir()
  return vim.fn.isdirectory(self.name) ~= 0
end

---@return boolean
function Path:isFile()
  return vim.fn.filereadable(self.name) ~= 0
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
