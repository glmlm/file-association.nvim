---@class Config
---@field ret_filepath table Enter the name of the filer plug-in for the key and the function that returns file path for the value
---@field exts table Associate exts to a program
local config = {
  ret_filepath = {},
  exts = {},
  filer = '',
}

---@class MyModule
local M = {}

---@type Config
M.config = config

---@class AssociationTable
local AssociationTable = require('file-association.association-table')
---@class DefaultFiler
local DefaultFiler = require('file-association.default-filer')
---@class Path
local Path = require('file-association.path')

---@param args Config?
M.setup = function(args)
  M.config = vim.tbl_deep_extend('force', M.config, args or {})
  local at = AssociationTable:new(M.config.exts)
  M.association_table = at.table
  local df = DefaultFiler:new(M.config.filer)
  M.default_filer = df.name
end

M.open_with = function()
  if not M.association_table then
    vim.notify("Association table is not initialized. Please call require('file-association').setup first.", 4)
    return 1
  else
    local path = Path:new(M.config.ret_filepath)

    if path:isDir() then
      if M.default_filer then
        vim.uv.spawn(M.default_filer, { args = { path.name } })
      else
        vim.notify('Could not open filer due to unsupported OS', 3)
      end
    elseif not path:isFile() then
      vim.notify('File not found: ' .. path.name, 3)
    else
      local program = M.association_table[path:getExtension()]
      if program then
        vim.uv.spawn(program, { args = { path.name } })
      else
        vim.ui.open(path.name)
      end
    end
    return 0
  end
end

M.copy_filepath = function()
  local path = Path:new(M.config.ret_filepath)

  if not path:isDir() and not path:isFile() then
    vim.notify('File not found: ' .. path.name, 3)
    return 1
  else
    local result = vim.fn.setreg('+', path.name)
    if result == 0 then
      vim.notify('Copied to clipboard')
    end
    return 0
  end
end

return M
