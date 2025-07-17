return {
  "nvim-telescope/telescope-file-browser.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  keys = {
    { "<leader>fb", "<cmd>Telescope file_browser path=%:p:h select_buffer=true<CR>", desc = "Find string under cursor in cwd" },
  },
}

