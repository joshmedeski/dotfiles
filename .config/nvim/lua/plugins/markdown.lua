return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" },
  opts = {
    preset = "obsidian",
    file_types = { "markdown", "Avante" },
    code = {
      style = "language",
      sign = false,
      width = "full",
      right_pad = 1,
    },
    heading = {
      width = "block",
      position = "overlay",
    },
  },
  ft = { "markdown", "Avante" },
}
