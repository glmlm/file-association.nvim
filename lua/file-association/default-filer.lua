---@class DefaultFiler
---@field name string
---@field errorlevel integer
local DefaultFiler = {}
DefaultFiler.__index = DefaultFiler

---@param userDefinedFiler string
---@return DefaultFiler
function DefaultFiler:new(userDefinedFiler)
	local obj = setmetatable({}, self)
	obj.name = self:_retFilerName(userDefinedFiler, vim.uv.os_uname().sysname)
	obj.errorlevel = self:_retErrorlevel(obj.name)
	return obj
end

---@param path string
---@return integer
function DefaultFiler:openDir(path)
	if self.errorlevel == 0 then
		vim.uv.spawn(self.name, { args = { path } })
	elseif self.errorlevel == 1 then
		vim.notify("Filer is not executable: " .. self.name, vim.log.levels.WARN, { title = "file-association.nvim" })
	else
		vim.notify(
			"Could not open default filer due to unsupported OS",
			vim.log.levels.ERROR,
			{ title = "file-association.nvim" }
		)
	end
	return self.errorlevel
end

---@param userDefinedFiler string
---@param sysname string
---@return string
function DefaultFiler:_retFilerName(userDefinedFiler, sysname)
	local filer
	if userDefinedFiler == "" then
		if sysname == "Darwin" then
			filer = "open"
		elseif sysname == "Windows_NT" then
			filer = "explorer"
		elseif sysname == "Linux" then
			filer = "xdg-open"
		end
	else
		filer = userDefinedFiler
	end
	return filer
end

---@param filer string
---@return integer
function DefaultFiler:_retErrorlevel(filer)
	local errorlevel
	if vim.fn.executable(filer) == 0 then
		if filer == "" then
			errorlevel = 2
		else
			errorlevel = 1
		end
	else
		errorlevel = 0
	end
	return errorlevel
end

return DefaultFiler
