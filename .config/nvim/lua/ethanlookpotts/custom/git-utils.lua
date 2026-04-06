local M = {}

-- Get changed line ranges from git diff for a file
M.get_changed_line_ranges = function(filepath)
	if not filepath or filepath == "" then
		return nil, "No filepath provided"
	end

	-- Check if git is available
	if vim.fn.executable("git") ~= 1 then
		return nil, "git not found in PATH"
	end

	-- Check if file is in a git repo
	local is_in_repo = vim.fn.system("git rev-parse --is-inside-work-tree 2>/dev/null")
	if vim.v.shell_error ~= 0 or not is_in_repo:match("true") then
		return nil, "Not in a git repository"
	end

	-- Get git diff for current file
	local result = vim.fn.system("git diff --no-ext-diff --unified=0 --no-color --no-prefix " .. vim.fn.shellescape(filepath))

	if vim.v.shell_error ~= 0 then
		return nil, "Could not get git diff (file may not be tracked or has no changes)"
	end

	-- Parse unified diff format to get changed line ranges
	local ranges = {}
	for line in result:gmatch("[^\r\n]+") do
		-- Match patterns like: @@ -1,2 +3,4 @@ or @@ -1 +1,2 @@
		local start_line, line_count = line:match("^@@%s+%-?%d+,?%d*%s+%+(%d+),?(%d*)%s+@@")
		if start_line then
			start_line = tonumber(start_line)
			line_count = tonumber(line_count) or 1
			if line_count > 0 then
				table.insert(ranges, {
					start = start_line,
					["end"] = start_line + line_count - 1,
				})
			end
		end
	end

	return #ranges > 0 and ranges or nil, nil
end

return M
