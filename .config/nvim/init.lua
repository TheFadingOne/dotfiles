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
-- vim.opt.background = 'dark'
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
-- pastetoggle was apparently removed in nvim
-- vim.opt.pt = '<F3>'
vim.opt.relativenumber = true
vim.opt.shiftwidth = 4
vim.opt.smarttab = true
vim.opt.undodir = os.getenv('XDG_STATE_HOME') .. '/nvim/undo'
vim.opt.undofile = true
vim.opt.wrap = true

vim.cmd(':filetype on')

-- hilighting
vim.api.nvim_set_hl(0, 'NormalFloat', { ctermbg = 8 })
vim.cmd.highlight({ "Normal", "ctermbg=NONE" })
vim.cmd.highlight({ "Normal", "guibg=NONE" })

-- colorscheme
require("catppuccin").setup({
    flavour = "mocha", -- latte, frappe, macchiato, mocha
    background = { -- :h background
        light = "latte",
        dark = "mocha",
    },
    transparent_background = true, -- disables setting the background color.
    show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
    term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
    dim_inactive = {
        enabled = false, -- dims the background color of inactive window
        shade = "dark",
        percentage = 0.15, -- percentage of the shade to apply to the inactive window
    },
    no_italic = false, -- Force no italic
    no_bold = false, -- Force no bold
    no_underline = false, -- Force no underline
    styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
        comments = { "italic" }, -- Change the style of comments
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
        -- miscs = {}, -- Uncomment to turn off hard-coded styles
    },
    color_overrides = {},
    custom_highlights = {},
    default_integrations = true,
    integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        notify = false,
        mini = {
            enabled = true,
            indentscope_color = "",
        },
        -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
    },
})

vim.cmd.colorscheme "catppuccin"


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

local diffview = require('diffview')

local devcontainer = require('devcontainer').setup {
  container_runtime = "podman",
  compose_command = "podman compose",
}

-- lsp-config

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)


vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP Actions',
  callback = function(event)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(event.buf, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap=true, silent=true, buffer=event.buf }
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

    local bufops = { noremap=true, silent=true, buffer=event.buf, async=true }
    vim.keymap.set('n', '<space>f', vim.lsp.buf.format, bufopts)
  end
})

local lspconfig = require('lspconfig')
local util = require('lspconfig.util')

local clangd_cmd = 'clangd'
if vim.fn.executable(clangd_cmd) == 1 then
    lspconfig['clangd'].setup {
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
        capabilities = capabilities,
        cmd = { gopls_cmd },
        filetype = { 'go', 'gomod', 'gotmpl' },
        root_dir = util.root_pattern('go.mod', '.git'),
        single_file_support = true,
    }
end

local isabelle_cmd = 'isabelle-ls'
if vim.fn.executable(isabelle_cmd) == 1 then
    require('isabelle-lsp').setup({
        isabelle_path = 'isabelle-ls',
    })

    lspconfig['isabelle'].setup {}
end

local hls_cmd = 'haskell-language-server-wrapper'
if vim.fn.executable(hls_cmd) == 1 then
    lspconfig['hls'].setup {
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

local ocamllsp_cmd = 'ocamllsp'
if vim.fn.executable(ocamllsp_cmd) == 1 then
    local language_id_of = {
      menhir = 'ocaml.menhir',
      ocaml = 'ocaml',
      ocamlinterface = 'ocaml.interface',
      ocamllex = 'ocaml.ocamllex',
      reason = 'reason',
      dune = 'dune',
    }

    local get_language_id = function(_, ftype)
      return language_id_of[ftype]
    end

    lspconfig['ocamllsp'].setup {
        capabilities = capabilities,
        cmd = { ocamllsp_cmd },
        filetypes = { "ocaml", "menhir", "ocamlinterface", "ocamllex", "reason", "dune" },
        root_dir = util.root_pattern('*.opam', 'esy.json', 'package.json', '.git', 'dune-project', 'dune-workspace'),
        get_language_id = get_language_id,
    }
end

local pylsp_cmd = 'pylsp'
if vim.fn.executable(pylsp_cmd) == 1 then
    lspconfig['pylsp'].setup {
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

local rust_analyzer_cmd = 'rust-analyzer'
if vim.fn.executable(rust_analyzer_cmd) == 1 then
    lspconfig['rust_analyzer'].setup {
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
        capabilities,
        cmd = { lua_cmd },
        filetype = { 'lua' },
        log_level = 2,
        root_dir = util.root_pattern(".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git"),
        single_file_support = true,
    }
end

local zls_cmd = 'zls'
if vim.fn.executable(zls_cmd) == 1 then
    lspconfig['zls'].setup {
        capabilities,
        cmd = { zls_cmd },
        filetype = { "zig", "zir" },
        root_dir = util.root_pattern("zls.json", "build.zig", ".git"),
        single_file_support = true,
    }
end

-- lspconfig['sumneko_lua'].setup {
--     on_attach = on_attach,
--     capabilities = capabilities,
--     settings = {
--         Lua = {
--             runtime = {
--                 version = 'LuaJIT',
--             },
--             diagnostics = {
--                 globals = {'vim'},
--             },
--             workspace = {
--                 library = vim.api.nvim_get_runtime_file("", true),
--             },
--             telemetry = {
--                 enable = false,
--             },
--         },
--     },
-- }

-- Lean
require('lean').setup {
    mappings = true,
}

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
