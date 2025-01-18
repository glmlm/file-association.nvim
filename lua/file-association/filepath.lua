---@return table
local function createClass()
  local class = {}
  class.__index = class

  function class:new(...)
    local obj = setmetatable({}, self)
    if obj.init then
      obj:init(...)
    end
    return obj
  end

  return class
end

---@param input string
---@return string
local function replaceEnvVar(input)
  local function retDirOrRawstr(env_var)
    return vim.env[env_var] or ('%' .. env_var .. '%')
  end
  local ret_value = string.gsub(input, '%%(.-)%%', retDirOrRawstr)
  return ret_value
end

---@param filetype string
---@param ret_filepath table
---@return string
local function retPath(filetype, ret_filepath)
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
    path = replaceEnvVar(filepath_raw)
  end

  return path
end

---@class FilePath
local FilePath = createClass()

---@param ret_filepath table
---@return FilePath
function FilePath:init(ret_filepath)
  self.path = retPath(vim.bo.filetype, ret_filepath)
  return self
end

---@return string|nil
function FilePath:getExtension()
  return self.path:match('%.([%w_]+)$')
end

return FilePath
