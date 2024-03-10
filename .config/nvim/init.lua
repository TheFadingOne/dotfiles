-- setup packer
require('plugins')

-- key mappings
-- normal mode
local kmopts = { noremap=true, silent=true }
vim.api.nvim_set_keymap('n', '<esc>', ':noh<CR>', kmopts)
vim.api.nvim_set_keymap('n', '<C-n>', ':bn<CR>', kmopts)
vim.api.nvim_set_keymap('n', '<C-p>', ':bp<CR>', kmopts)
vim.api.nvim_set_keymap('n', '<C-d>', ':bd<CR>', kmopts)
vim.api.nvim_set_keymap('n', '<C-h>', ':hide<CR>', kmopts)

-- insert mode
vim.api.nvim_set_keymap('i', 'jk', '<esc>', kmopts)

-- variable settings
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.cindent = true
vim.opt.autoread = true
vim.opt.autowrite = false
vim.opt.background = 'dark'
vim.opt.backspace = 'indent,eol,start'
vim.opt.backup = true -- make sure if I want that
vim.opt.backupcopy = 'yes'
vim.opt.backupdir = os.getenv('XDG_DATA_HOME') .. '/nvim/.backup,.'
vim.opt.backupext = '~'
vim.opt.breakindent = true
vim.opt.bufhidden = '' -- maybe change this?
vim.opt.buflisted = true
vim.opt.expandtab = true
vim.opt.hidden = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.linebreak = true
vim.opt.list = true
vim.opt.listchars = 'tab:>-,trail:_,nbsp:+'
vim.opt.number = true
vim.opt.pt = '<F3>'
vim.opt.relativenumber = true
vim.opt.shiftwidth = 4
vim.opt.smarttab = true
vim.opt.undodir = os.getenv('XDG_STATE_HOME') .. '/nvim/undo'
vim.opt.undofile = true
vim.opt.wrap = true

vim.cmd(':filetype on')

-- hilighting
vim.api.nvim_set_hl(0, 'NormalFloat', { ctermbg = 8 })

-- nvim-cmp capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Using Lua functions
local builtin = require('telescope.builtin')
local tkmopts = { noremap = true }
vim.keymap.set('n', '<leader>ff', builtin.find_files, tkmopts)
vim.keymap.set('n', '<leader>fg', builtin.live_grep, tkmopts)
vim.keymap.set('n', '<leader>fb', builtin.buffers, tkmopts)
vim.keymap.set('n', '<leader>fh', builtin.help_tags, tkmopts)

-- lsp-config

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)


local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
end

local lspconfig = require('lspconfig')
local util = require('lspconfig.util')

-- lspconfig['ccls'].setup {
--     on_attach = on_attach,
--     capabilities = capabilities,
--     init_options = {
--         compilationDatabaseDirectory = "build",
--         index = {
--             threads = 0;
--         },
--         clang = {
--             excludeArgs = { "-frounding-math" },
--         },
--     },
--     cmd = { 'ccls' },
--     filetype = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
--     offset_encoding = "utf-32",
--     root_dir = util.root_pattern('compile_commands.json', '.ccls', '.git'),
--     single_file_support = false,
-- }

local clangd_cmd = 'clangd'
if vim.fn.executable(clangd_cmd) == 1 then
    lspconfig['clangd'].setup {
        on_attach = on_attach,
        capabilities = capabilities,
        cmd = { clangd_cmd },
        filetype = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
        root_dir = util.root_pattern('.clangd',
                                     '.clang-tidy',
                                     '.clang-format',
                                     'compile_commands.json',
                                     'compile_flags.txt',
                                     'configure.ac',
                                     '.git'),
    }
end

local gopls_cmd = 'gopls'
if vim.fn.executable(gopls_cmd) == 1 then
    lspconfig['gopls'].setup {
        on_attach = on_attach,
        capabilities = capabilities,
        cmd = { gopls_cmd },
        filetype = { 'go', 'gomod', 'gotmpl' },
        root_dir = util.root_pattern('go.mod', '.git'),
        single_file_support = true,
    }
end

local hls_cmd = 'haskell-language-server-wrapper'
if vim.fn.executable(hls_cmd) == 1 then
    lspconfig['hls'].setup {
        on_attach = on_attach,
        capabilities = capabilities,
        cmd = { hls_cmd, '--lsp' },
        filetype = { 'haskell', 'lhaskell' },
        root_dir = function (filepath)
            return (
                util.root_pattern('hie.yaml', 'stack.yaml', 'cabal.project')(filepath)
                or util.root_pattern('*.cabal', 'package.yaml')(filepath)
            )
        end,
        settings = {
            haskell = {
                formattingProvider = 'ormulo'
            }
        },
        single_file_support = true,
    }
end

local pylsp_cmd = 'pylsp'
if vim.fn.executable(pylsp_cmd) == 1 then
    lspconfig['pylsp'].setup {
        on_attach = on_attach,
        capabilities = capabilities,
        cmd = { pylsp_cmd },
        filetypes = { 'python' },
        root_dir = function(fname)
          local root_files = {
            'pyproject.toml',
            'setup.py',
            'setup.cfg',
            'requirements.txt',
            'Pipfile',
          }
          return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname)
        end,
        single_file_support = true,
    }
end

local rust_analyzer_cmd = 'rust_analyzer'
if vim.fn.executable(rust_analyzer_cmd) == 1 then
    lspconfig['rust_analyzer'].setup {
        on_attach = on_attach,
        capabilities = capabilities,
        cmd = { rust_analyzer_cmd },
        filetype = { 'rust' },
        root_dir = util.root_pattern('Cargo.toml', 'rust-project.json'),
        settings = {
            ['rust-analyzer'] = {}
        },
    }
end

local lua_cmd = 'lua_language_server'
if vim.fn.executable(lua_cmd) == 1 then
    lspconfig['lua_ls'].setup {
        on_attach,
        capabilities,
        cmd = { 'lua_language_server' },
        filetype = { 'lua' },
        log_level = 2,
        root_dir = util.root_pattern(".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git"),
        single_file_support = true,
    }
end

-- setup snippet engine
local luasnip = require('luasnip')

-- setup nvim_cmp
local cmp = require('cmp')
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}
