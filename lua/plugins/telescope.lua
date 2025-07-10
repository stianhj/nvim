return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  },
  config = function()
    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<space>fh", builtin.help_tags, {})
    vim.keymap.set("n", "<space>pf", builtin.find_files, {})
    vim.keymap.set("n", "<space>pb", builtin.buffers, {})

    vim.keymap.set('n', '<space>en', function()
      local opts = require("telescope.themes").get_ivy({
        cwd = vim.fn.stdpath("config")
      })
      builtin.find_files(opts)
    end)

    vim.keymap.set("n", "<space>of", function()
      builtin.find_files({
        cwd = "/usr/lib/odin",
      })
    end)

    require "plugins.telescope.multigrep".setup()
  end
}
