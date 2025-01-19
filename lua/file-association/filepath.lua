---@class FilePath
---@field path string
local FilePath = {}
FilePath.__index = FilePath

---@param retFilepath table
---@return FilePath
function FilePath:new(retFilepath)
  local obj = setmetatable({}, self)
  obj.path = FilePath:_retPath(vim.bo.filetype, retFilepath)
  return obj
end

---@return string|nil
function FilePath:getExtension()
  return self.path:match('%.([%w_]+)$')
end

---@param input string
---@return string
function FilePath:_replaceEnvVar(input)
  local function retDirOrRawstr(env_var)
    return vim.env[env_var] or ('%' .. env_var .. '%')
  end
  local ret_value = string.gsub(input, '%%(.-)%%', retDirOrRawstr)
  return ret_value
end

---@param filetype string
---@param ret_filepath table
---@return string
function FilePath:_retPath(filetype, ret_filepath)
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
    path = FilePath:_replaceEnvVar(filepath_raw)
  end

  return path
end

return FilePath
