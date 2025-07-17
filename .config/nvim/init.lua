if vim.g.vscode then
	require("ethanlookpotts.vscode")
else
	require("ethanlookpotts.core")
	require("ethanlookpotts.lazy")
end
