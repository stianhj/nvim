vim.cmd([[
set hidden
set vb t_vb=
set guioptions=
set fillchars=vert:\ ,fold:-
set list listchars=tab:\›\ ,trail:·,extends:>
set ts=2 sts=2 sw=2 expandtab
set incsearch
set smartcase
set ignorecase
set autoindent
set smartindent
set nomousehide
set nowrap
set novisualbell
set mouse=a
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*.hi,*.o
set clipboard=unnamedplus
set lazyredraw
set autowrite
set notermguicolors
set t_Co=256
set signcolumn=yes
set bg=dark

command! RemoveTrailingWhitespace :%s/\s\+$//
]])

vim.opt.inccommand = "nosplit"
vim.opt.encoding = "utf-8"
vim.opt.diffopt = "internal,filler,closeoff"
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

local rocks_config = {
	rocks_path = vim.env.HOME .. "/.local/share/nvim/rocks",
}

vim.g.rocks_nvim = rocks_config

local luarocks_path = {
	vim.fs.joinpath(rocks_config.rocks_path, "share", "lua", "5.1", "?.lua"),
	vim.fs.joinpath(rocks_config.rocks_path, "share", "lua", "5.1", "?", "init.lua"),
}
package.path = package.path .. ";" .. table.concat(luarocks_path, ";")

local luarocks_cpath = {
	vim.fs.joinpath(rocks_config.rocks_path, "lib", "lua", "5.1", "?.so"),
	vim.fs.joinpath(rocks_config.rocks_path, "lib64", "lua", "5.1", "?.so"),
	-- Remove the dylib and dll paths if you do not need macos or windows support
	vim.fs.joinpath(rocks_config.rocks_path, "lib", "lua", "5.1", "?.dylib"),
	vim.fs.joinpath(rocks_config.rocks_path, "lib64", "lua", "5.1", "?.dylib"),
	vim.fs.joinpath(rocks_config.rocks_path, "lib", "lua", "5.1", "?.dll"),
	vim.fs.joinpath(rocks_config.rocks_path, "lib64", "lua", "5.1", "?.dll"),
}
package.cpath = package.cpath .. ";" .. table.concat(luarocks_cpath, ";")

vim.opt.runtimepath:append(vim.fs.joinpath(rocks_config.rocks_path, "lib", "luarocks", "rocks-5.1", "rocks.nvim", "*"))

require("packer").startup(function()
  use "wbthomason/packer.nvim"

  use "neovim/nvim-lspconfig"
  use "hrsh7th/cmp-nvim-lsp"
  use "hrsh7th/cmp-buffer"
  use "hrsh7th/nvim-cmp"

  use "scrooloose/nerdtree"
  use "scrooloose/nerdcommenter"
  use "tpope/vim-fugitive"

  use "nvim-lua/plenary.nvim"
  use "nvim-telescope/telescope.nvim"
  use "nvim-treesitter/nvim-treesitter"

  use "ruanyl/vim-gh-line"

  use "norcalli/nvim-colorizer.lua"

  use "ziglang/zig.vim"
  use "vim-perl/vim-perl"
  use "tikhomirov/vim-glsl"
  use "leafOfTree/vim-vue-plugin"
  use "maxbane/vim-asm_ca65"
  use "joerdav/templ.vim"

  use "MunifTanjim/prettier.nvim"
  use "sbdchd/neoformat"

  use "EdenEast/nightfox.nvim"
  use "ntk148v/komau.vim"

  use "vimwiki/vimwiki"
end)

vim.opt.termguicolors = true
require"colorizer".setup()

--vim.cmd("color carbonfox")
vim.cmd("color komau")

vim.cmd("autocmd! BufRead,BufNewFile *.qtpl set filetype=html")
vim.cmd("autocmd FileType perl setlocal shiftwidth=2 softtabstop=2 noexpandtab")
vim.cmd("autocmd! BufRead,BufNewFile *.h set filetype=c")
vim.cmd("autocmd Filetype c setlocal tabstop=8 textwidth=100 shiftwidth=8 noexpandtab cindent formatoptions=tcqlron cinoptions=:0,l1,t0,g0 cinkeys-=0#")
vim.cmd("autocmd Filetype uxntal setlocal tabstop=4 textwidth=100 shiftwidth=4 noexpandtab")

vim.cmd([[
let g:vimwiki_list = [{'path': '~/sync/unvimwiki', 'syntax': 'markdown', 'ext': '.md'}]")
let g:vimwiki_folding = 'expr'
set foldlevelstart=99
]])

vim.g.gh_gitlab_domain = "git.0x484c.com"
vim.g.gh_open_command = 'fn() { echo "$@" | xclip -selection clipboard; }; fn '

local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>t", ":NERDTreeToggle<CR>", opts)
vim.keymap.set("n", "<leader>f", ":NERDTreeFind<CR>", opts)
vim.keymap.set("n", "<space><tab>", ":b#<CR>", opts)

vim.keymap.set("n", "<space>gs", ":vert G<CR>", opts)
vim.keymap.set("n", "<space>gd", ":Gdiff<CR>", opts)
vim.keymap.set("n", "<space>ge", ":Gedit<CR>", opts)
vim.keymap.set("n", "<space>gr", ":Gread<CR>", opts)
vim.keymap.set("n", "<space>gw", ":Gwrite<CR><CR>", opts)
vim.keymap.set("n", "<space>gl", ":silent! Git log<CR>:bot copen<CR>", opts)

vim.keymap.set("n", "<space>mf", ":Neoformat<CR>", opts)

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<space>pf", builtin.find_files, {})
vim.keymap.set("n", "<space>pb", builtin.buffers, {})
vim.keymap.set('n', '<space>/', builtin.live_grep, {})
vim.keymap.set("n", "<space>ps", builtin.lsp_document_symbols, {})
vim.keymap.set("n", "<space>pg", function()
  builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)

local on_attach = function(_, bufnr)
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, bufopts)
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
  vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)

  vim.keymap.set("n", "]g", vim.diagnostic.goto_next)
  vim.keymap.set("n", "[g", vim.diagnostic.goto_prev)
  vim.keymap.set("n", "<space>]", vim.diagnostic.goto_next)
  vim.keymap.set("n", "<space>[", vim.diagnostic.goto_prev)
end

-- treesitter
require"nvim-treesitter.configs".setup{
  highlight = {
    enable = true,
  },
}

require"neorg".setup{
  load = {
    ["core.defaults"] = {},
    ["core.concealer"] = {},
    ["core.dirman"] = {
      config = {
        workspaces = {
          notes = "~/sync/notes",
        },
      },
    },
  },
}

-- zig
require"lspconfig".zls.setup{
  on_attach = on_attach,
}

-- typescript
require"lspconfig".ts_ls.setup{
  on_attach = on_attach,
}

-- golang
require"lspconfig".gopls.setup{
  on_attach = on_attach,
}

require"lspconfig".perlnavigator.setup{
  cmd = { "perlnavigator", "--stdio" },
  on_attach = on_attach,
  settings = {
    perlnavigator = {
      perlPath = '/home/x/.local/bin/cperl',
    }
  }
}

require"lspconfig".ccls.setup{
  on_attach = on_attach,
}

require'lspconfig'.volar.setup{
  on_attach = on_attach,
  filetypes = {'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json'}
 }

require"lspconfig".lua_ls.setup{
  on_attach = on_attach,
  settings = {
    Lua = {
      diagnostics = {
        enable = true,
        globals = {'vim', 'describe', 'use'},
        disable = {"lowercase-global"}
      },
      workspace = {
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
        },
      },
    },
  }
}

require'lspconfig'.templ.setup{}

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.templ" },
  callback = function()
    vim.lsp.buf.format()
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.go" },
  callback = function()
    local params = vim.lsp.util.make_range_params(nil, "utf-16")
    params.context = { only = { "source.organizeImports" } }
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
    for _, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          vim.lsp.util.apply_workspace_edit(r.edit, "utf-16")
        else
          vim.lsp.buf.execute_command(r.command)
        end
      end
    end
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.go" },
  callback = function()
    vim.lsp.buf.format()
  end,
})

local prettier = require("prettier")

prettier.setup({
  bin = 'prettier',
  filetypes = {
    "css",
    "graphql",
    "html",
    "javascript",
    "json",
    "less",
    "markdown",
    "scss",
    "typescript",
    "typescriptreact",
    "yaml",
  },
})

-- completion
local cmp = require"cmp"
cmp.setup({
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    {
      name = 'buffer',
      option = {
        get_bufnrs = function()
          local buf = vim.api.nvim_get_current_buf()
          local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
          if byte_size > 1024 * 1024 then -- 1 Megabyte max
            return {}
          end
          local bufs = {}
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            bufs[vim.api.nvim_win_get_buf(win)] = true
          end
          return vim.tbl_keys(bufs)
        end
      }
    }
  }),
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<Tab>'] = cmp.mapping.confirm({ select = true }),
  }),
})
