return {
  "tpope/vim-fugitive",
  config = function()
    local opts = { noremap = true, silent = true }
    vim.keymap.set("n", "<space>gs", ":vert G<CR>", opts)
    vim.keymap.set("n", "<space>gd", ":Gdiff<CR>", opts)
    vim.keymap.set("n", "<space>ge", ":Gedit<CR>", opts)
    vim.keymap.set("n", "<space>gr", ":Gread<CR>", opts)
    vim.keymap.set("n", "<space>gw", ":Gwrite<CR><CR>", opts)
    vim.keymap.set("n", "<space>gl", ":silent! Git log<CR>:bot copen<CR>", opts)
  end
}
