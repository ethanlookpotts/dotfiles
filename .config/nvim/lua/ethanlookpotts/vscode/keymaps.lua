-- set leader key to comma
vim.g.mapleader = ","
vim.g.maplocalleader = ","

local keymap = vim.keymap -- for conciseness

------------------- General Keymaps -------------------

-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- workspace navigation
keymap.set("n", "<leader>fb", "<cmd>lua require('vscode').action('workbench.files.action.focusFilesExplorer')<CR>", { desc = "Focus file explorer" })
keymap.set("n", "<leader>fc", "<cmd>lua require('vscode').action('aichat.newfollowupaction')<CR>", { desc = "Focus cursor composer" })
keymap.set("n", "<leader>ft", "<cmd>lua require('vscode').action('workbench.action.terminal.focus')<CR>", { desc = "Focus terminal" })

-- grep/search
keymap.set("n", "<leader>gc", "<cmd>lua require('vscode').action('workbench.action.showCommands')<CR>", { desc = "Show command palette" })
keymap.set("n", "<leader>gf", "<cmd>lua require('vscode').action('workbench.action.quickOpen')<CR>", { desc = "Quick open file" })
keymap.set("n", "<leader>gs", "<cmd>lua require('vscode').action('workbench.action.findInFiles')<CR>", { desc = "Find in files" })
keymap.set("n", "<leader>gw", function()
    local code = require("vscode")
    code.action("workbench.action.findInFiles", {
        args = { query = vim.fn.expand('<cword>') }
    })
end, { desc = "Find current word in files" })

-- cursor
keymap.set("n", "<leader>cc", "<cmd>lua require('vscode').action('composer.createNew')<CR>", { desc = "Create new with Cursor composer" })
keymap.set("v", "<leader>cc", "<cmd>lua require('vscode').action('editor.action.addSymbolToChat')<CR>", { desc = "Create new with Cursor composer" })
keymap.set("n", "<leader>ck", "<cmd>lua require('vscode').action('aipopup.action.modal.generate')<CR>", { desc = "Open Cursor AI popup" })

-- split windows
keymap.set("n", "<leader>sv", "<cmd>lua require('vscode').action('workbench.action.splitEditor')<CR>", { desc = "Split editor vertically" })
keymap.set("n", "<leader>sh", "<cmd>lua require('vscode').action('workbench.action.splitEditorDown')<CR>", { desc = "Split editor horizontally" })
keymap.set("n", "<leader>se", "<cmd>lua require('vscode').action('workbench.action.evenEditorWidths')<CR>", { desc = "Make split editors even width" })
keymap.set("n", "<leader>sx", "<cmd>lua require('vscode').action('workbench.action.closeEditorsInGroup')<CR>", { desc = "Close all editors in group" })
keymap.set("n", "<leader>sn", "<cmd>lua require('vscode').action('workbench.action.moveEditorToNextGroup')<CR>", { desc = "Move to next editor group" })
keymap.set("n", "<leader>sp", "<cmd>lua require('vscode').action('workbench.action.moveEditorToPreviousGroup')<CR>", { desc = "Move to previous editor group" })
-- tab + group navigation
keymap.set("n", "<C-j>", "<cmd>lua require('vscode').action('workbench.action.focusBelowGroup')<CR>", { desc = "Focus group below" })
keymap.set("n", "<C-k>", "<cmd>lua require('vscode').action('workbench.action.focusAboveGroup')<CR>", { desc = "Focus group above" })
keymap.set("n", "<C-h>", "<cmd>lua require('vscode').action('workbench.action.focusLeftGroup')<CR>", { desc = "Focus group to the left" })
keymap.set("n", "<C-l>", "<cmd>lua require('vscode').action('workbench.action.focusRightGroup')<CR>", { desc = "Focus group to the right" })
keymap.set("n", "<S-h>", "<cmd>lua require('vscode').action('workbench.action.previousEditor')<CR>", { desc = "Go to previous editor" })
keymap.set("n", "<S-l>", "<cmd>lua require('vscode').action('workbench.action.nextEditor')<CR>", { desc = "Go to next editor" })

-- misc
keymap.set("n", "<leader>mp", "<cmd>lua require('vscode').action('editor.action.formatChanges')<CR>", { desc = "Format document" })
keymap.set("n", "<leader>rs", function()
    local code = require("vscode")
    code.action("vscode-neovim.restart")
    code.action("bazel.lsp.restart")
    code.action("go.languageserver.restart")
    code.action("python.analysis.restartLanguageServer")
    code.action("autopep8.restart")
end, { desc = "Restart extensions and language servers" })
keymap.set("n", "<leader>d", "<cmd>lua require('vscode').action('editor.action.showDefinitionPreviewHover')<CR>", { desc = "Show hover" })
