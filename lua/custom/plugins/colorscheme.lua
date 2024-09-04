return {
  "rose-pine/nvim",
  name = "rose-pine",
  priority = 1000,
  opts = {
    styles = {
      italic = false,
    },
  },
  init = function()
    vim.cmd("colorscheme rose-pine")
  end,
}
