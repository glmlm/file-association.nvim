---@class DefaultFiler
---@field name string|nil
local DefaultFiler = {}
DefaultFiler.__index = DefaultFiler

---@param userDefinedFiler string
---@return DefaultFiler
function DefaultFiler:new(userDefinedFiler)
  local obj = setmetatable({}, self)
  obj.name = self:_retFiler(userDefinedFiler, vim.uv.os_uname().sysname)
  return obj
end

---@param userDefinedFiler string
---@param sysname string
---@return string|nil
function DefaultFiler:_retFiler(userDefinedFiler, sysname)
  local filer
  if userDefinedFiler == '' then
    if sysname == 'Darwin' then
      filer = 'open'
    elseif sysname == 'Windows_NT' then
      filer = 'explorer'
    elseif sysname == 'Linux' then
      filer = 'xdg-open'
    end
  else
    filer = userDefinedFiler
  end

  return filer
end

return DefaultFiler
