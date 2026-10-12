return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main", -- Critical: Must use 'main' for Neovim 0.12
  build = ":TSUpdate",
  lazy = false,    -- Ensure parsers are available before buffers load
  config = function()
    local ts = require("nvim-treesitter")
    local parsers = require("nvim-treesitter.parsers")

    vim.api.nvim_create_autocmd("User", {
      pattern = "TSUpdate",
      callback = function()
        parsers.janet_simple = {
          install_info = {
            url = "https://github.com/sogaiu/tree-sitter-janet-simple",
            revision = nil,
            branch = "master",
            queries = "queries",
          },
        }
      end,
    })

    vim.treesitter.language.register("janet_simple", { "janet" })

    -- 1. Install parsers (replaces 'ensure_installed')
    ts.install({
      "c", "lua", "odin", "vim", "vimdoc", "query",
      "markdown", "markdown_inline", "rust", "janet_simple",
    })

    -- 2. Recreate your custom logic via Autocmds
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("TreesitterSetup", { clear = true }),
      callback = function(args)
        local buf = args.buf
        local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)

        -- Skip if no language or already attached
        if not lang or vim.treesitter.get_parser(buf, lang, { error = false }) then
          return
        end

        -- 3. Replicate your 'disable' function for large files
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          -- File too large, skip treesitter (fallback to regex syntax if enabled)
          return
        end

        -- 4. Enable Highlighting (Native in 0.12)
        pcall(vim.treesitter.start, buf, lang)

        -- 5. Enable Indentation (Provided by nvim-treesitter)
        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
