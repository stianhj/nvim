vim.cmd([[
set hidden
set vb t_vb=
set guioptions=
set fillchars=vert:\ ,fold:-
set list listchars=tab:\ \ ,trail:·
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

command! RemoveTrailingWhitespace :%s/\s\+$//
]])

vim.opt.inccommand = "nosplit"
vim.opt.encoding = "utf-8"
vim.g.mapleader = ","

require("packer").startup(function()
  use "wbthomason/packer.nvim"

  use "neovim/nvim-lspconfig"
  use "hrsh7th/cmp-nvim-lsp"
  use "hrsh7th/cmp-buffer"
  --use "hrsh7th/cmp-path"
  --use "hrsh7th/cmp-cmdline"
  use "hrsh7th/nvim-cmp"

  use "scrooloose/nerdtree"
  use "scrooloose/nerdcommenter"
  use "tpope/vim-fugitive"
  use "ziglang/zig.vim"

  use "nvim-lua/plenary.nvim"
  use "nvim-telescope/telescope.nvim"

  use "folke/tokyonight.nvim"

  use "https://git.sr.ht/~sircmpwn/hare.vim"

  use "ruanyl/vim-gh-line"

  use "leafOfTree/vim-vue-plugin"
end)

vim.cmd("color tokyonight-moon")

vim.cmd("autocmd! BufRead,BufNewFile *.qtpl set filetype=html")

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

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<space>pf", builtin.find_files, {})
vim.keymap.set("n", "<space>pb", builtin.buffers, {})

local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  local bufopts = { noremap=true, silent=true, buffer=bufnr }
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
end

-- zig
require"lspconfig".zls.setup{
  on_attach = on_attach,
}

-- typescript
require"lspconfig".tsserver.setup{
  on_attach = on_attach,
}

-- golang
require"lspconfig".gopls.setup{
  on_attach = on_attach,
}

require"lspconfig".perlpls.setup{
  on_attach = on_attach,
}

require"lspconfig".ccls.setup{
  on_attach = on_attach,
}

require'lspconfig'.volar.setup{
  on_attach = on_attach,
  filetypes = {'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json'}
 }

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
    vim.lsp.buf.formatting_sync(nil, 500)
  end,
})

-- completion
local cmp = require"cmp"
cmp.setup({
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'buffer' },
  })
})
