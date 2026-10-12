return {
  "catgoose/nvim-colorizer.lua",
  ft = { "css", "scss", "sass" },
  config = function()
    vim.opt.termguicolors = true
    require "colorizer".setup()
  end
}
