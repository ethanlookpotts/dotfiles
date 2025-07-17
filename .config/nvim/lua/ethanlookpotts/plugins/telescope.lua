return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		telescope.setup({
			defaults = {
				path_display = { "truncate " },
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
					},
				},
				file_ignore_patterns = {
					"node_modules",
					".git/",
					".DS_Store",
				},
			},
		})

		telescope.load_extension("fzf")

		-- set keymaps
		local keymap = vim.keymap -- for conciseness

		keymap.set("n", "<leader>ff", "<cmd>Telescope find_files hidden=true<CR>", { desc = "Fuzzy find files in cwd" })
		keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>", { desc = "Fuzzy find recent files" })
		keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep hidden=true<CR>", { desc = "Find string in cwd" })
		keymap.set(
			"n",
			"<leader>fw",
			"<cmd>Telescope grep_string hidden=true<CR>",
			{ desc = "Find string under cursor in cwd" }
		)
		keymap.set(
			"n",
			"<leader>fb",
			"<cmd>Telescope file_browser hidden=true path=%:p:h select_buffer=true<CR>",
			{ desc = "Open file browser" }
		)
		keymap.set("n", "<leader>fc", "<cmd>Telescope commands<CR>", { desc = "Find vim commands" })
		keymap.set(
			"n",
			"<leader>fd",
			"<cmd>Telescope lsp_document_symbols<CR>",
			{ desc = "Find symbols from document" }
		)
	end,
}
