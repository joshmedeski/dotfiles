return {
  "vuki656/package-info.nvim",
  dependencies = { "folke/which-key.nvim", "MunifTanjim/nui.nvim" },
  ft = { "json" },
  opts = {
    -- FIX: colors don't render in wezterm (inside tmux)
    -- colors = {
    --   up_to_date = "#B1D99C", -- Text color for up to date dependency virtual text
    --   outdated = "#EAAC86", -- Text color for outdated dependency virtual text
    -- },
    autostart = true,
    hide_up_to_date = true,
    hide_unstable_versions = false,
    package_manager = "pnpm",
  },
  keys = function()
    require("which-key").add({ { "<leader>n", group = "PackageInfo", icon = "" } })
    local function map(key, cmd, desc)
      vim.keymap.set({ "n" }, "<LEADER>n" .. key, cmd, { desc = desc, silent = true, noremap = true })
    end
    local pi = require("package-info")
    map("s", pi.show, "Show package info")
    map("h", pi.hide, "Hide package info")
    map("n", pi.toggle, "Toggle package info")
    map("u", pi.update, "Update package")
    map("d", pi.delete, "Delete package")
    map("i", pi.install, "Install package")
    map("v", pi.change_version, "Change package version")
  end,
}
