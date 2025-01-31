vim.cmd [[
  augroup jdtls_lsp
    autocmd!
    autocmd FileType java lua require('core.jdtls').setup_jdtls()
  augroup end
]]
