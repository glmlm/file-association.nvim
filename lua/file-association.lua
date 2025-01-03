-- main module file
local module = require('file-association.module')

---@class Config
---@field ret_filepath table Enter the name of the filer plug-in for the key and the function that returns file path for the value
---@field exts table Associate exts to a program
local config = {
  ret_filepath = {},
  exts = {},
  filer = '',
}

---@class FilePath
---@field path string
local FilePath = {}
FilePath.__index = FilePath

---@param ret_filepath table
---@return FilePath
function FilePath.new(ret_filepath)
  local self = setmetatable({}, FilePath)
  local filetype = vim.bo.filetype
  local filepath = module.ret_path(filetype, ret_filepath)
  self.path = filepath
  return self
end

---@return string
function FilePath:get_filepath()
  return self.path
end

---@return string|nil
function FilePath:get_extension()
  return self.path:match('%.([%w_]+)$')
end

---@class MyModule
local M = {}

---@type Config
M.config = config
M.file_associated_table = nil

---@param args Config?
M.setup = function(args)
  M.config = vim.tbl_deep_extend('force', M.config, args or {})
  M.file_associated_table = module.create_association_table(M.config.exts)
end

M.open_with = function()
  if not M.file_associated_table then
    vim.notify("Association table is not initialized. Please call require('gx-associated').setup first.", 4)
    return 1
  else
    local fp = FilePath.new(M.config.ret_filepath)
    local filepath = fp:get_filepath()
    local file_ext = fp:get_extension()

    local is_directory = vim.fn.isdirectory(filepath)
    local file_exist = vim.fn.filereadable(filepath)
    if is_directory ~= 0 then
      local filer
      if M.config.filer == '' then
        local sysname = vim.uv.os_uname().sysname
        if sysname == 'Darwin' then
          filer = 'open'
        elseif sysname == 'Windows_NT' then
          filer = 'explorer'
        elseif sysname == 'Linux' then
          filer = 'xdg-open'
        end
      else
        filer = M.config.filer
      end

      if filer then
        vim.uv.spawn(filer, { args = { filepath } })
      else
        vim.notify('Could not open filer due to unsupported OS', 3)
      end
    elseif file_exist == 0 then
      vim.notify('File not found: ' .. filepath, 3)
    else
      local program = M.file_associated_table[file_ext]
      if program then
        vim.uv.spawn(program, { args = { filepath } })
      else
        vim.ui.open(filepath)
      end
    end
    return 0
  end
end

return M
