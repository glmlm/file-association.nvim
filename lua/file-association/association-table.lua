---@class AssociationTable
---@field table table
local AssociationTable = {}
AssociationTable.__index = AssociationTable

---@param prog_exts table
---@return AssociationTable
function AssociationTable:new(prog_exts)
  local obj = setmetatable({}, self)
  obj.table = self:_retAssociationTable(prog_exts)
  return obj
end

---@param input string
---@return string
function AssociationTable:_replaceEnvVar(input)
  local function retDirOrRawstr(env_var)
    return vim.env[env_var] or ('%' .. env_var .. '%')
  end
  local ret_value = string.gsub(input, '%%(.-)%%', retDirOrRawstr)
  return ret_value
end

---@param prog_exts table
---@return table
function AssociationTable:_retAssociationTable(prog_exts)
  local association_table = {}
  for prog, exts in pairs(prog_exts) do
    for _, ext in ipairs(exts) do
      local prog_env = self:_replaceEnvVar(prog)
      association_table[ext] = prog_env
    end
  end

  return association_table
end

return AssociationTable
