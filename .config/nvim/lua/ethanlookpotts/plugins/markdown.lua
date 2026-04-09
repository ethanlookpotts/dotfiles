return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  ft = { "markdown" },
  build = "sh -c 'cd app && ./install.sh'",
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
  end,
}
