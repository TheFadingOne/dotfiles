vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    use 'neovim/nvim-lspconfig'
    use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
    use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
    use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
    use 'L3MON4D3/LuaSnip' -- Snippet engine
    use 'fatih/vim-go'
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.4',
        requires = { {'nvim-lua/plenary.nvim'} }
    } -- File searching
    use {
        'Julian/lean.nvim',
        requires = { {'nvim-lua/plenary.nvim'} }
    } -- lean stuff
    use "sindrets/diffview.nvim" -- git diff view
    use {
        "catppuccin/nvim",
        as = "catppuccin"
    }

    -- isabelle
    use 'Treeniks/isabelle-syn.nvim'
    use {
        'Treeniks/isabelle-lsp.nvim',
        branch = 'isabelle-language-server',
        requires = { {'neovim/nvim-lspconfig'} }
    }

    -- devcontainer
    use {
        'https://codeberg.org/esensar/nvim-dev-container',
        requires = { {'nvim-treesitter/nvim-treesitter'} }
    }
end)
