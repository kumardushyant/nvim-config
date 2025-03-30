return {
  "scottmckendry/cyberdream.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("cyberdream").setup({
      theme = "dark",
      colorscheme = "gruvbox",
      transparent = true,
      disable_background = false,
      disable_italics = false,
      disable_bold = false,
      disable_underline = false,
      disable_cursorline = false,
      disable_signs = false,
      disable_statusline = false,
      disable_tabline = false,
      disable_winbar = false,
      disable_folds = false,
      disable_indent_blankline = false,
      disable_lsp_signature_help = false,
      disable_lsp_diagnostics = false,
      disable_lsp_highlight_references = false,
      disable_lsp_highlight_implementations = false,
      disable_lsp_highlight_definitions = false,
      disable_lsp_highlight_references_in_comments_and_strings = false,
      disable_lsp_highlight_references_in_comments_and_strings_in_insert_mode = false
    })
  end,
  init = function()
    vim.cmd("colorscheme cyberdream")
  end,
}
