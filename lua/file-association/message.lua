---@class Message
---@field title string
local Message = {}
Message.__index = Message

---@return Message
function Message:new()
  local obj = setmetatable({}, self)
  obj.title = 'file-association.nvim'
  return obj
end

---@param message string
---@param log_level string
function Message:display(message, log_level)
  local log_levels = {
    trace = vim.log.levels.TRACE,
    debug = vim.log.levels.DEBUG,
    info = vim.log.levels.INFO,
    warn = vim.log.levels.WARN,
    error = vim.log.levels.ERROR,
    off = vim.log.levels.OFF,
  }
  local level = log_levels['info']
  for type, lv in pairs(log_levels) do
    if log_level == type then
      level = lv
      break
    end
  end
  vim.notify(message, level, { title = self.title })
end

return Message
