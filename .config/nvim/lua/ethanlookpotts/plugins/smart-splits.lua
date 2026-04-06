return {
	"mrjones2014/smart-splits.nvim",
	lazy = false,
	config = function()
		require("smart-splits").setup({
			ignored_filetypes = { "nofile", "quickfix", "prompt" },
			ignored_buftypes = { "NvimTree" },
			default_amount = 2,
			at_edge = "wrap",
			move_cursor_same_row = false,
			cursor_follows_swapped_bufs = false,
			resize_mode = {
				quit_key = "<ESC>",
				resize_keys = { "h", "j", "k", "l" },
				silent = false,
			},
			ignored_events = {
				"BufEnter",
				"WinEnter",
			},
			multiplexer_integration = "tmux",
			disable_multiplexer_nav_when_zoomed = true,
		})

		local keymap = vim.keymap

		-- Navigation
		keymap.set("n", "<C-h>", require("smart-splits").move_cursor_left, { desc = "Move to left split" })
		keymap.set("n", "<C-j>", require("smart-splits").move_cursor_down, { desc = "Move to split below" })
		keymap.set("n", "<C-k>", require("smart-splits").move_cursor_up, { desc = "Move to split above" })
		keymap.set("n", "<C-l>", require("smart-splits").move_cursor_right, { desc = "Move to right split" })

		-- Resizing
		keymap.set("n", "<M-h>", require("smart-splits").resize_left, { desc = "Resize split left" })
		keymap.set("n", "<M-j>", require("smart-splits").resize_down, { desc = "Resize split down" })
		keymap.set("n", "<M-k>", require("smart-splits").resize_up, { desc = "Resize split up" })
		keymap.set("n", "<M-l>", require("smart-splits").resize_right, { desc = "Resize split right" })
	end,
}
