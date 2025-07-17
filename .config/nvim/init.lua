if vim.g.vscode then
	require("ethanlook.vscode")
else
	require("ethanlook.core")
	require("ethanlook.lazy")
end
