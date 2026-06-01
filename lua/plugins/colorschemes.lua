return {
  {
    "EdenEast/nightfox.nvim",
    config = function()
    end,
  },
  {
    "tek256/simple-dark",
    config = function()
    end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      vim.cmd.colorscheme "tokyonight"
    end,
  }
}
