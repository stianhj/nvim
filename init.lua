print("hello nvim")

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

command! RemoveTrailingWhitespace :%s/\s\+$//
]])

require("config.lazy")

vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>")
vim.keymap.set("n", "<space>x", ".lua<CR>")
vim.keymap.set("v", "<space>x", ":lua<CR>")

vim.keymap.set("n", "<M-j>", "<cmd>cnext<CR>")
vim.keymap.set("n", "<M-k>", "<cmd>cprev<CR>")

vim.keymap.set("n", "-", "<cmd>Oil<CR>")

vim.keymap.set("n", "<space><tab>", ":b#<CR>")

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = 'Highlight when yanking text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.opt.inccommand = "nosplit"
vim.opt.encoding = "utf-8"
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"
