return {
  {
    'stevearc/oil.nvim',
    opts = {
      columns = {
        "icon",
        -- "permissions",
        "size",
        "mtime",
      },
    },
    dependencies = { { 'echasnovski/mini.icons', opts = {} } },
  },
}
