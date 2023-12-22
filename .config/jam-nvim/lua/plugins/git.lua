return {
  {
    "lewis6991/gitsigns.nvim", -- Git integration for buffers
    event = "BufReadPre",
    opts = function()
      -- local icons = require 'config.icons'
      --- @type Gitsigns.Config
      local C = {
        -- signs = {
        --   add = { text = icons.git.added },
        --   change = { text = icons.git.changed },
        --   delete = { text = icons.git.deleted },
        --   topdelete = { text = icons.git.deleted },
        --   changedelete = { text = icons.git.changed },
        --   untracked = { text = icons.git.added },
        -- },
        on_attach = function(buffer)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, desc)
            vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
          end

          map({ "n", "v" }, "<leader>gx", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
          map("n", "<leader>gh", gs.preview_hunk, "Preview Hunk")
          map("n", "<leader>gX", gs.reset_buffer, "Reset Buffer")
          map("n", "<leader>gp", gs.preview_hunk, "Preview Hunk")
          map("n", "<leader>gb", function()
            gs.blame_line({ full = true })
          end, "Blame Line")
          map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
        end,
      }
      return C
    end,
    keys = {
      -- git stage
      { "<leader>gg", ":Gitsigns stage_hunk<CR>", desc = "Stage Hunk" },
      { "<leader>gG", ":Gitsigns stage_buffer<CR>", desc = "Stage Buffer" },
      { "<leader>gu", ":Gitsigns undo_stage_hunk<CR>", desc = "Undo Stage Hunk" },

      -- git hunk navigation
      { "gh", ":Gitsigns next_hunk<CR>", desc = "Goto next git hunk" },
      { "gH", ":Gitsigns prev_hunk<CR>", desc = "Goto previous git hunk" },
      { "]g", ":Gitsigns next_hunk<CR>", desc = "Goto next git hunk" },
      { "[g", ":Gitsigns prev_hunk<CR>", desc = "Goto previous git hunk" },
    },
  },
}
