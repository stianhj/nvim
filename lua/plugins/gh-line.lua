return {
  {
    "ruanyl/vim-gh-line",
    config = function()
      vim.g.gh_gitlab_domain = "git.0x484c.com"
      vim.g.gh_open_command = 'fn() { echo "$@" | xclip -selection clipboard; }; fn '
    end,
  },
}
