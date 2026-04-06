return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
	},
	config = function()
		local compat = require("ethanlookpotts.core.compat")

		compat.with_suppressed_deprecations({ "nvim-lspconfig" }, function()
			local lspconfig = require("lspconfig")
			local cmp_nvim_lsp = require("cmp_nvim_lsp")
			local servers = require("ethanlookpotts.lsp.servers")
			local keymap = vim.keymap

			-- LSP keybinds for buffers with LSP attached
			local on_attach = function(client, bufnr)
				-- Ensure offset_encoding is set (fixes nvim 0.11.1 symbols_to_items error)
				if not client.offset_encoding then
					client.offset_encoding = "utf-16"
				end

				local opts = { buffer = bufnr, noremap = true, silent = true }
				local function map(mode, lhs, rhs, desc)
					keymap.set(mode, lhs, rhs, vim.tbl_extend("force", opts, { desc = desc }))
				end

				map("n", "gr", "<cmd>Telescope lsp_references<CR>", "Show LSP references")
				map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
				map("n", "gd", "<cmd>Telescope lsp_definitions<CR>", "Show LSP definitions")
				map("n", "gi", "<cmd>Telescope lsp_implementations<CR>", "Show LSP implementations")
				map("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", "Show LSP type definitions")
				map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "See available code actions")
				map("n", "<leader>rn", vim.lsp.buf.rename, "Smart rename")
				map("n", "K", vim.lsp.buf.hover, "Show documentation for what is under cursor")
				map("n", "<leader>rs", ":LspRestart<CR>", "Restart LSP")
			end

			-- Enable autocompletion
			local capabilities = cmp_nvim_lsp.default_capabilities()

			-- Set default position encoding to utf-16 (fixes nvim 0.11 warning)
			capabilities.general = capabilities.general or {}
			capabilities.general.positionEncodings = { "utf-16", "utf-8" }

			-- Configure diagnostic symbols
			local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
			vim.diagnostic.config({
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = signs.Error,
						[vim.diagnostic.severity.WARN] = signs.Warn,
						[vim.diagnostic.severity.HINT] = signs.Hint,
						[vim.diagnostic.severity.INFO] = signs.Info,
					},
				},
			})

			-- Setup simple servers
			for _, server_name in ipairs(servers.simple_servers) do
				lspconfig[server_name].setup({
					capabilities = capabilities,
					on_attach = on_attach,
				})
			end

			-- Setup custom servers
			for server_name, config in pairs(servers.custom_servers) do
				local server_config = vim.tbl_deep_extend("force", {
					capabilities = capabilities,
					on_attach = function(client, bufnr)
						on_attach(client, bufnr)
						if config.on_attach_extra then
							config.on_attach_extra(client, bufnr)
						end
					end,
				}, config)

				-- Remove on_attach_extra from final config as it's not a real LSP option
				server_config.on_attach_extra = nil

				lspconfig[server_name].setup(server_config)
			end
		end)
	end,
}
