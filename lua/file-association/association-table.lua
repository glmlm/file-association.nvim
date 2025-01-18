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

---@param prog_exts table
---@return table
local function retAssociationTable(prog_exts)
  local association_table = {}
  for prog, exts in pairs(prog_exts) do
    for _, ext in ipairs(exts) do
      local prog_env = replaceEnvVar(prog)
      association_table[ext] = prog_env
    end
  end

  return association_table
end

---@class AssociationTable
local AssociationTable = createClass()

---@param prog_exts table
---@return AssociationTable
function AssociationTable:init(prog_exts)
  self.association_table = retAssociationTable(prog_exts)
  return self
end

return AssociationTable
