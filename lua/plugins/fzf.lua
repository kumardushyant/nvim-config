return {
    "ibhagwan/fzf-lua",
    config = function()
        -- calling `setup` is optional for customization
        require("fzf-lua").setup({
            {
              "telescope",
              "fzf-native"
            },
            winopts={
              fullscreen=true
            },
            hls = { border = "FloatBorder" },
            fzf_colors = true
        }
    )
    end,
    keys = {
        { '<leader>ff', '<cmd>FzfLua files<cr>', desc = 'FzfLua files' },
        { '<leader>fg', '<cmd>FzfLua grep<cr>', desc = "FzfLua grep" },
        { '<leader>fb', '<cmd>FzfLua buffers<cr>', desc = "FzfLua buffers" },
        { '<leader>fh', '<cmd>FzfLua help_tags<cr>', desc = "FzfLua help_tags" },
        { '<leader>fl', '<cmd>FzfLua live_grep<cr>', desc = "FzfLua live_grep" },
        { '<leader>fm', '<cmd>FzfLua marks<cr>', desc = "FzfLua marks" },
        { '<leader>fr', '<cmd>FzfLua oldfiles<cr>', desc = "FzfLua oldfiles" },
        { '<leader>fs', '<cmd>FzfLua lsp_workspace_symbols<cr>', desc = "FzfLua lsp_workspace_symbols" },
        { '<leader>ft', '<cmd>FzfLua lsp_document_symbols<cr>', desc = "FzfLua lsp_document_symbols" },
        { '<leader>fw', '<cmd>FzfLua lsp_workspace_diagnostics<cr>', desc = "FzfLua lsp_workspace_diagnostics" },
        { '<leader>fq', '<cmd>FzfLua quickfix<cr>', desc = "FzfLua quickfix" },
        { '<leader>fl', '<cmd>FzfLua loclist<cr>', desc = "FzfLua loclist" },
    },
    lazy=false
}