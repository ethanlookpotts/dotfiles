-- set leader key to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keymap = vim.keymap -- for conciseness

------------------- General Keymaps -------------------

-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- delete single character without copying into register
-- keymap.set("n", "x", '"_x')

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- open cheatsheet
keymap.set("n", "<leader>ch", "<cmd>!open https://ethanlookpotts.github.io/dotfiles/<CR>", { desc = "Open cheatsheet" })

-- yank code with file paths for Claude Code
local yank = require("ethanlookpotts.custom.yank")
keymap.set("v", "<leader>yr", function()
	yank.yank_visual_with_path(yank.get_buffer_cwd_relative(), "relative")
end, { desc = "Yank code with relative path" })
keymap.set("v", "<leader>ya", function()
	yank.yank_visual_with_path(yank.get_buffer_absolute(), "absolute")
end, { desc = "Yank code with absolute path" })

-- git diff view
keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<CR>", { desc = "Open git diff view" })
keymap.set("n", "<leader>gD", "<cmd>DiffviewOpen main...HEAD<CR>", { desc = "Git diff against main" })

------------------- Diagnostics (LSP + Linters) -------------------

keymap.set("n", "<leader>db", "<cmd>Telescope diagnostics bufnr=0<CR>", { desc = "Show buffer diagnostics" })
keymap.set("n", "<leader>dl", vim.diagnostic.open_float, { desc = "Show line diagnostics" })
keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })

------------------- Window Management -------------------
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab
