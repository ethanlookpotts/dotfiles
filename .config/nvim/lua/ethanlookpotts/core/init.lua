require("ethanlookpotts.core.keymaps")
require("ethanlookpotts.core.options")

-- Initialize directory watcher and hotreload for Claude Code integration
require("ethanlookpotts.custom.directory-watcher").setup()
require("ethanlookpotts.custom.hotreload").setup()
