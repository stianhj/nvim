return {
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme "carbonfox"
      vim.opt_local.fillchars = { vert = "│", horiz = "─" }
    end,
  },
  {
    "tek256/simple-dark",
    config = function()
    end,
  },
  {
    "folke/tokyonight.nvim",
    opts = {},
    -- config = function()
    --   vim.cmd.colorscheme "tokyonight"
    -- end,
  }
}
