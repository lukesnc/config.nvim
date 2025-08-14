-- Opts
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.scrolloff = 10
vim.opt.wrap = false

vim.opt.undofile = true
vim.opt.updatetime = 250
vim.opt.clipboard = "unnamedplus"

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- List of plugins
local plugins = {
  { -- Colorscheme
    "rose-pine/nvim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    config = function()
      require("rose-pine").setup({
        styles = {
          italic = false,
        },
        disable_background = true,
        disable_float_background = true,
      })

      vim.cmd("colorscheme rose-pine-moon")
    end,
  },

  -- Detect tabstop and shiftwidth automatically
  { "NMAC427/guess-indent.nvim", opts = {} },

  -- Gitsigns
  { "lewis6991/gitsigns.nvim", opts = {} },

  { -- LSP
    "mason-org/mason-lspconfig.nvim",
    opts = {},
    dependencies = {
      "neovim/nvim-lspconfig",
      { "mason-org/mason.nvim", opts = {} },
      {
        "j-hui/fidget.nvim",
        opts = { notification = { window = { winblend = 0 } } },
      },
    },
  },

  { -- Autocompletion
    "saghen/blink.cmp",
    version = "1.*",
    opts = {
      fuzzy = { implementation = "prefer_rust" },
    },
  },

  { -- Autoformat
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          markdown = { "mdformat" },
          javascript = { "prettierd" },
          html = { "prettierd" },
          css = { "prettierd" },
        },
      })

      vim.keymap.set("n", "<leader>F", function()
        require("conform").format({ async = true, lsp_format = "fallback" })
      end)
    end,
  },

  { -- Treesitter
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "bash",
          "html",
          "c",
          "diff",
          "lua",
          "vim",
          "vimdoc",
          "query",
          "markdown",
          "markdown_inline",
        },
        sync_install = false,
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  { -- Telescope
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = {
            "%.git[/\\]",
            "node_modules",
            "target[/\\]",
            "build[/\\]",
            "%.trash[/\\]",
            "%.obsidian[/\\]",
          },
        },
        pickers = {
          find_files = {
            hidden = true,
          },
        },
      })

      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
    end,
  },
}

-- Setup lazy.nvim
require("lazy").setup({ spec = plugins })

-- Misc settings go down here
