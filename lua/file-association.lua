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
---@class FilePath
local FilePath = require('file-association.filepath')

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
    vim.notify("Association table is not initialized. Please call require('gx-associated').setup first.", 4)
    return 1
  else
    local fp = FilePath:new(M.config.ret_filepath)
    local filepath = fp.path
    local file_ext = fp:getExtension()

    local is_directory = vim.fn.isdirectory(filepath)
    local file_exist = vim.fn.filereadable(filepath)
    if is_directory ~= 0 then
      if M.default_filer then
        vim.uv.spawn(M.default_filer, { args = { filepath } })
      else
        vim.notify('Could not open filer due to unsupported OS', 3)
      end
    elseif file_exist == 0 then
      vim.notify('File not found: ' .. filepath, 3)
    else
      local program = M.association_table[file_ext]
      if program then
        vim.uv.spawn(program, { args = { filepath } })
      else
        vim.ui.open(filepath)
      end
    end
    return 0
  end
end

M.copy_filepath = function()
  local fp = FilePath:new(M.config.ret_filepath)
  local filepath = fp.path

  local file_exist = vim.fn.filereadable(filepath)
  local is_directory = vim.fn.isdirectory(filepath)
  if file_exist == 0 and is_directory == 0 then
    vim.notify('File not found: ' .. filepath, 3)
    return 1
  else
    vim.fn.setreg('+', filepath)
    return 0
  end
end

return M
