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

vim.opt.undofile = true
vim.opt.updatetime = 250
vim.opt.clipboard = "unnamedplus"

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Add plugins
vim.pack.add({
  -- Colorscheme
  { src = "https://github.com/rose-pine/neovim" },
  -- Guess indent
  { src = "https://github.com/NMAC427/guess-indent.nvim" },
  -- Gitsigns
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
  -- LSP
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
  { src = "https://github.com/j-hui/fidget.nvim" },
  -- Treesitter
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  -- Telescope
  { src = "https://github.com/nvim-telescope/telescope.nvim", version = vim.version.range("0.1.*") },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  -- Autoformat
  { src = "https://github.com/stevearc/conform.nvim" },
  -- Autocomplete
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },
})

-- Configure plugins
require("rose-pine").setup({
  styles = {
    italic = false,
  },
  disable_background = true,
  disable_float_background = true,
})
vim.cmd("colorscheme rose-pine-moon")

require("guess-indent").setup({})

require("mason").setup({})
require("mason-lspconfig").setup({})

require("fidget").setup({
  notification = { window = { winblend = 0 } },
})

require("blink.cmp").setup({
  fuzzy = { implementation = "prefer_rust" },
})

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

require("telescope").setup({
  defaults = {
    file_ignore_patterns = {
      "%.git[/\\]",
      "node_modules",
      "target[/\\]",
      "build[/\\]",
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

-- Misc settings go down here
