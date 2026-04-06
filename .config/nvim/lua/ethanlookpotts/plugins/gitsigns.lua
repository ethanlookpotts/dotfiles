return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local gitsigns = require("gitsigns")

		gitsigns.setup({
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Git operations
				map("n", "<leader>gp", gs.preview_hunk, { desc = "Preview git hunk" })
				map("n", "<leader>gb", gs.blame_line, { desc = "Git blame line" })
				map("n", "<leader>gs", gs.stage_hunk, { desc = "Stage git hunk" })
				map("n", "<leader>gr", gs.reset_hunk, { desc = "Reset git hunk" })
			end,
		})
	end,
}
