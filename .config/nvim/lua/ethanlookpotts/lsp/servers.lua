local M = {}

-- LSP servers with default configuration
M.simple_servers = {
	"html",
	"ts_ls",
	"cssls",
	"tailwindcss",
	"prismals",
	"gopls",
}

-- LSP servers with custom configuration
M.custom_servers = {
	pyright = {
		settings = {
			python = {
				analysis = {
					extraPaths = { "external/" },
					exclude = { "bazel-*" },
				},
			},
		},
	},

	lua_ls = {
		settings = {
			Lua = {
				diagnostics = {
					globals = { "vim" },
				},
				workspace = {
					library = {
						[vim.fn.expand("$VIMRUNTIME/lua")] = true,
						[vim.fn.stdpath("config") .. "/lua"] = true,
					},
				},
			},
		},
	},

	svelte = {
		on_attach_extra = function(client, bufnr)
			vim.api.nvim_create_autocmd("BufWritePost", {
				pattern = { "*.js", "*.ts" },
				callback = function(ctx)
					if client.name == "svelte" then
						client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.file })
					end
				end,
			})
		end,
	},

	graphql = {
		filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
	},

	emmet_ls = {
		filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
	},
}

return M
