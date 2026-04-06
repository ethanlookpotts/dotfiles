local M = {}

-- Temporarily suppress deprecation warnings from specific plugins
M.with_suppressed_deprecations = function(plugins, callback)
	local old_deprecate = vim.deprecate

	vim.deprecate = function(name, alternative, version, plugin, backtrace)
		if vim.tbl_contains(plugins, plugin) then
			return
		end
		old_deprecate(name, alternative, version, plugin, false)
	end

	local ok, result = pcall(callback)
	vim.deprecate = old_deprecate

	if not ok then
		error(result)
	end

	return result
end

return M
