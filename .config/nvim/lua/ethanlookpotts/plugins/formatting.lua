return {
	"stevearc/conform.nvim",
	config = function()
		local conform = require("conform")
		local git_utils = require("ethanlookpotts.custom.git-utils")

		-- Build formatters_by_ft programmatically
		local js_formatters = { "prettier", "eslint_d" }
		local prettier_only = { "prettier" }

		local formatters_by_ft = {
			css = prettier_only,
			html = prettier_only,
			json = prettier_only,
			yaml = prettier_only,
			markdown = prettier_only,
			graphql = prettier_only,
			lua = { "stylua" },
			python = { "ruff_format", "ruff_organize_imports" },
			go = { "gofmt" },
		}

		-- Add JS/TS filetypes
		for _, ft in ipairs({ "javascript", "typescript", "javascriptreact", "typescriptreact", "svelte" }) do
			formatters_by_ft[ft] = js_formatters
		end

		conform.setup({
			formatters_by_ft = formatters_by_ft,
			formatters = {
				prettier = {
					prepend_args = { "--print-width", "100", "--prose-wrap", "always" },
				},
			},
		})

		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "Format file or range (in visual mode)" })

		vim.keymap.set("n", "<leader>mc", function()
			local filepath = vim.fn.expand("%:p")
			local ranges, err = git_utils.get_changed_line_ranges(filepath)

			if not ranges then
				vim.notify(err or "No changed lines to format", vim.log.levels.INFO)
				return
			end

			-- Format each range
			for _, range in ipairs(ranges) do
				conform.format({
					lsp_fallback = true,
					async = false,
					timeout_ms = 1000,
					range = {
						start = { range.start, 0 },
						["end"] = { range["end"], 0 },
					},
				})
			end

			vim.notify(string.format("Formatted %d region(s)", #ranges), vim.log.levels.INFO)
		end, { desc = "Format only changed lines" })
	end,
}
