return {
  'andythigpen/nvim-coverage',
  dependencies = { 'nvim-lua/plenary.nvim' },
  -- cmd = { 'CoverageToggle', 'CoverageLoad', 'CoverageLoad' },
  keys = {
    -- TODO: investigate improving loading strategy directly in plugin code
    -- https://github.com/andythigpen/nvim-coverage/issues/35
    { '<leader>tc', '<cmd>CoverageLoad<cr><cmd>CoverageToggle<cr>', desc = '[t]est [c]overage toggle' },
    { '<leader>tC', '<cmd>CoverageLoad<cr><cmd>CoverageSummary<cr>', desc = '[t]est [C]overage summary' },
  },
  opts = {
    signs = {
      -- use your own highlight groups or text markers
      covered = { hl = 'CoverageCovered', text = '▎' },
      uncovered = { hl = 'CoverageUncovered', text = '▎' },
    },
    auto_reload = true,
    lang = {
      go = {
        coverage_file = vim.fn.getcwd() .. '/coverage.out',
      },
      typescript = {
        coverage_file = vim.fn.getcwd() .. '/coverage/lcov.info',
      },
    },
  },
}
