local M = {}

local uv = vim.uv
local watcher = nil
local debounce_timer = nil
local on_change_handlers = {}

-- Debounce helper to prevent callback storms
local debounce = function(fn, delay)
	return function(...)
		local args = { ... }
		if debounce_timer then
			debounce_timer:close()
		end
		debounce_timer = vim.defer_fn(function()
			debounce_timer = nil
			fn(unpack(args))
		end, delay)
	end
end

-- Register a named handler to be called when files change
-- If a handler with the same name exists, it will be replaced
-- Note: Named handlers are required to support Lua hotreload - when a file is reloaded,
-- it re-registers its handler with the same name, replacing the old one instead of
-- creating duplicates
M.registerOnChangeHandler = function(name, handler)
	on_change_handlers[name] = handler
end

-- Start watching a directory for file changes
M.setup = function(opts)
	opts = opts or {}
	local path = opts.path or vim.fn.getcwd()
	local debounce_delay = opts.debounce or 100 -- ms

	-- Stop existing watcher if any
	if watcher then
		M.stop()
	end

	-- Create fs_event handle
	local fs_event = uv.new_fs_event()
	if not fs_event then
		return false
	end

	-- Debounced callback for file changes
	local on_change = debounce(function(err, filename, events)
		if err then
			M.stop()
			return
		end

		if filename then
			local full_path = path .. "/" .. filename

			-- Call all registered handlers
			for _, handler in pairs(on_change_handlers) do
				pcall(handler, full_path, events)
			end
		end
	end, debounce_delay)

	-- Patterns to ignore (performance optimization)
	local ignore_patterns = {
		"node_modules",
		"%.git/",
		"bazel%-",
		"%.cache/",
		"%.next/",
		"dist/",
		"build/",
		"target/",
		"%.venv/",
		"venv/",
		"__pycache__/",
	}

	local function should_ignore(filepath)
		for _, pattern in ipairs(ignore_patterns) do
			if filepath:match(pattern) then
				return true
			end
		end
		return false
	end

	-- Wrap on_change to filter ignored paths
	local filtered_on_change = function(err, filename, events)
		if err or not filename or should_ignore(filename) then
			return
		end
		on_change(err, filename, events)
	end

	-- Start watching (wrapped for thread safety)
	local ok, err = fs_event:start(path, { recursive = true }, vim.schedule_wrap(filtered_on_change))

	if ok ~= 0 then
		vim.notify(
			string.format("Failed to start directory watcher on %s: %s", path, tostring(err)),
			vim.log.levels.WARN
		)
		return false, err
	end

	watcher = fs_event
	return true
end

-- Stop the watcher and clean up resources
M.stop = function()
	if watcher then
		watcher:stop()
		watcher = nil
	end

	if debounce_timer then
		debounce_timer:close()
		debounce_timer = nil
	end
end

return M
