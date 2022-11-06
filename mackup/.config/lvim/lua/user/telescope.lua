local M = {}

M.config = function()
  lvim.builtin.telescope = {
    active = true,
    defaults = {
      sorting_strategy = "ascending",
      prompt_prefix = " ",
      prompt_position = "top"
    },
    pickers = {
      buffers = {
        layout_config = {
          preview_width = 0.0,
          prompt_position = "top"
        }
      },
      live_grep = {
        layout_config = {
          preview_width = 0.6,
          prompt_position = "top"
        }
      },
      find_files = {
        layout_config = {
          prompt_position = "top"
        }
      },
      git_files = {
        show_untracked = true,
        layout_config = {
          prompt_position = "top"
          -- TODO: sort by last_modified
        }
      },
      commands = {
        layout_config = {
          prompt_position = "top"
        }
      },
      git_status = {
        layout_config = {
          prompt_position = "top"
        }
      }
    }
  }

  lvim.builtin.telescope.on_config_done = function(telescope)
    -- pcall(telescope.load_extension, "frecency")
    -- pcall(telescope.load_extension, "neoclip")
    pcall(telescope.load_extension, "harpoon")
  end
end

return M
