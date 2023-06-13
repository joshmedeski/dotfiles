return {
  "pwntester/octo.nvim",
  cmd = "Octo",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("octo").setup({
      default_remote = { "upstream", "origin" }, -- order to try remotes
      enable_builtin = true,
      ssh_aliases = {}, -- SSH aliases. e.g. `ssh_aliases = {["github.com-work"] = "github.com"}`
      reaction_viewer_hint_icon = "", -- marker for user reactions
      user_icon = " ", -- user icon
      timeline_marker = "", -- timeline marker
      timeline_indent = "2", -- timeline indentation
      right_bubble_delimiter = "", -- bubble delimiter
      left_bubble_delimiter = "", -- bubble delimiter
      github_hostname = "", -- GitHub Enterprise host
      snippet_context_lines = 4, -- number or lines around commented lines
      gh_env = {}, -- extra environment variables to pass on to GitHub CLI, can be a table or function returning a table
      issues = {
        order_by = { -- criteria to sort results of `Octo issue list`
          field = "CREATED_AT", -- either COMMENTS, CREATED_AT or UPDATED_AT (https://docs.github.com/en/graphql/reference/enums#issueorderfield)
          direction = "DESC", -- either DESC or ASC (https://docs.github.com/en/graphql/reference/enums#orderdirection)
        },
      },
      pull_requests = {
        order_by = { -- criteria to sort the results of `Octo pr list`
          field = "CREATED_AT", -- either COMMENTS, CREATED_AT or UPDATED_AT (https://docs.github.com/en/graphql/reference/enums#issueorderfield)
          direction = "DESC", -- either DESC or ASC (https://docs.github.com/en/graphql/reference/enums#orderdirection)
        },
        always_select_remote_on_create = "false", -- always give prompt to select base remote repo when creating PRs
      },
      file_panel = {
        size = 10, -- changed files panel rows
        use_icons = true, -- use web-devicons in file panel (if false, nvim-web-devicons does not need to be installed)
      },
      mappings = {
        issue = {
          close_issue = { lhs = "<space>ic", desc = "close issue" },
          reopen_issue = { lhs = "<space>io", desc = "reopen issue" },
          list_issues = { lhs = "<space>il", desc = "list open issues on same repo" },
          reload = { lhs = "<C-r>", desc = "reload issue" },
          open_in_browser = { lhs = "<C-b>", desc = "open issue in browser" },
          copy_url = { lhs = "<C-y>", desc = "copy url to system clipboard" },
          add_assignee = { lhs = "<space>aa", desc = "add assignee" },
          remove_assignee = { lhs = "<space>ad", desc = "remove assignee" },
          create_label = { lhs = "<space>lc", desc = "create label" },
          add_label = { lhs = "<space>la", desc = "add label" },
          remove_label = { lhs = "<space>ld", desc = "remove label" },
          goto_issue = { lhs = "<space>gi", desc = "navigate to a local repo issue" },
          add_comment = { lhs = "<space>ca", desc = "add comment" },
          delete_comment = { lhs = "<space>cd", desc = "delete comment" },
          next_comment = { lhs = "]c", desc = "go to next comment" },
          prev_comment = { lhs = "[c", desc = "go to previous comment" },
          react_hooray = { lhs = "<space>rp", desc = "add/remove 🎉 reaction" },
          react_heart = { lhs = "<space>rh", desc = "add/remove ❤️ reaction" },
          react_eyes = { lhs = "<space>re", desc = "add/remove 👀 reaction" },
          react_thumbs_up = { lhs = "<space>r+", desc = "add/remove 👍 reaction" },
          react_thumbs_down = { lhs = "<space>r-", desc = "add/remove 👎 reaction" },
          react_rocket = { lhs = "<space>rr", desc = "add/remove 🚀 reaction" },
          react_laugh = { lhs = "<space>rl", desc = "add/remove 😄 reaction" },
          react_confused = { lhs = "<space>rc", desc = "add/remove 😕 reaction" },
        },
        pull_request = {
          checkout_pr = { lhs = "<space>po", desc = "checkout PR" },
          merge_pr = { lhs = "<space>pm", desc = "merge commit PR" },
          squash_and_merge_pr = { lhs = "<space>psm", desc = "squash and merge PR" },
          list_commits = { lhs = "<space>pc", desc = "list PR commits" },
          list_changed_files = { lhs = "<space>pf", desc = "list PR changed files" },
          show_pr_diff = { lhs = "<space>pd", desc = "show PR diff" },
          add_reviewer = { lhs = "<space>va", desc = "add reviewer" },
          remove_reviewer = { lhs = "<space>vd", desc = "remove reviewer request" },
          close_issue = { lhs = "<space>ic", desc = "close PR" },
          reopen_issue = { lhs = "<space>io", desc = "reopen PR" },
          list_issues = { lhs = "<space>il", desc = "list open issues on same repo" },
          reload = { lhs = "<C-r>", desc = "reload PR" },
          open_in_browser = { lhs = "<C-b>", desc = "open PR in browser" },
          copy_url = { lhs = "<C-y>", desc = "copy url to system clipboard" },
          goto_file = { lhs = "gf", desc = "go to file" },
          add_assignee = { lhs = "<space>aa", desc = "add assignee" },
          remove_assignee = { lhs = "<space>ad", desc = "remove assignee" },
          create_label = { lhs = "<space>lc", desc = "create label" },
          add_label = { lhs = "<space>la", desc = "add label" },
          remove_label = { lhs = "<space>ld", desc = "remove label" },
          goto_issue = { lhs = "<space>gi", desc = "navigate to a local repo issue" },
          add_comment = { lhs = "<space>ca", desc = "add comment" },
          delete_comment = { lhs = "<space>cd", desc = "delete comment" },
          next_comment = { lhs = "]c", desc = "go to next comment" },
          prev_comment = { lhs = "[c", desc = "go to previous comment" },
          react_hooray = { lhs = "<space>rp", desc = "add/remove 🎉 reaction" },
          react_heart = { lhs = "<space>rh", desc = "add/remove ❤️ reaction" },
          react_eyes = { lhs = "<space>re", desc = "add/remove 👀 reaction" },
          react_thumbs_up = { lhs = "<space>r+", desc = "add/remove 👍 reaction" },
          react_thumbs_down = { lhs = "<space>r-", desc = "add/remove 👎 reaction" },
          react_rocket = { lhs = "<space>rr", desc = "add/remove 🚀 reaction" },
          react_laugh = { lhs = "<space>rl", desc = "add/remove 😄 reaction" },
          react_confused = { lhs = "<space>rc", desc = "add/remove 😕 reaction" },
        },
        review_thread = {
          goto_issue = { lhs = "<space>gi", desc = "navigate to a local repo issue" },
          add_comment = { lhs = "<space>ca", desc = "add comment" },
          add_suggestion = { lhs = "<space>sa", desc = "add suggestion" },
          delete_comment = { lhs = "<space>cd", desc = "delete comment" },
          next_comment = { lhs = "]c", desc = "go to next comment" },
          prev_comment = { lhs = "[c", desc = "go to previous comment" },
          select_next_entry = { lhs = "]q", desc = "move to previous changed file" },
          select_prev_entry = { lhs = "[q", desc = "move to next changed file" },
          close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
          react_hooray = { lhs = "<space>rp", desc = "add/remove 🎉 reaction" },
          react_heart = { lhs = "<space>rh", desc = "add/remove ❤️ reaction" },
          react_eyes = { lhs = "<space>re", desc = "add/remove 👀 reaction" },
          react_thumbs_up = { lhs = "<space>r+", desc = "add/remove 👍 reaction" },
          react_thumbs_down = { lhs = "<space>r-", desc = "add/remove 👎 reaction" },
          react_rocket = { lhs = "<space>rr", desc = "add/remove 🚀 reaction" },
          react_laugh = { lhs = "<space>rl", desc = "add/remove 😄 reaction" },
          react_confused = { lhs = "<space>rc", desc = "add/remove 😕 reaction" },
        },
        submit_win = {
          approve_review = { lhs = "<C-a>", desc = "approve review" },
          comment_review = { lhs = "<C-m>", desc = "comment review" },
          request_changes = { lhs = "<C-r>", desc = "request changes review" },
          close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
        },
        review_diff = {
          add_review_comment = { lhs = "<space>ca", desc = "add a new review comment" },
          add_review_suggestion = { lhs = "<space>sa", desc = "add a new review suggestion" },
          focus_files = { lhs = "<leader>e", desc = "move focus to changed file panel" },
          toggle_files = { lhs = "<leader>b", desc = "hide/show changed files panel" },
          next_thread = { lhs = "]t", desc = "move to next thread" },
          prev_thread = { lhs = "[t", desc = "move to previous thread" },
          select_next_entry = { lhs = "]q", desc = "move to previous changed file" },
          select_prev_entry = { lhs = "[q", desc = "move to next changed file" },
          close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
          toggle_viewed = { lhs = "<leader><space>", desc = "toggle viewer viewed state" },
        },
        file_panel = {
          next_entry = { lhs = "j", desc = "move to next changed file" },
          prev_entry = { lhs = "k", desc = "move to previous changed file" },
          select_entry = { lhs = "<cr>", desc = "show selected changed file diffs" },
          refresh_files = { lhs = "R", desc = "refresh changed files panel" },
          focus_files = { lhs = "<leader>e", desc = "move focus to changed file panel" },
          toggle_files = { lhs = "<leader>b", desc = "hide/show changed files panel" },
          select_next_entry = { lhs = "]q", desc = "move to previous changed file" },
          select_prev_entry = { lhs = "[q", desc = "move to next changed file" },
          close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
          toggle_viewed = { lhs = "<leader><space>", desc = "toggle viewer viewed state" },
        },
      },
    })

    vim.cmd([[hi OctoEditable guibg=none]])
  end,
  keys = function()
    local wk = require("which-key")
    wk.register({ mode = { "n" }, ["<leader>o"] = { name = "+Octo" } })
    wk.register({ mode = { "n" }, ["<leader>oi"] = { name = "+issue" } })
    wk.register({ mode = { "n" }, ["<leader>op"] = { name = "+pr" } })

    return {
      -- issues
      { "<leader>oi/", "<cmd>Octo issue search<cr>", desc = "Search issues" },
      { "<leader>oii", "<cmd>Octo issue create<cr>", desc = "Create issue" },
      { "<leader>oil", "<cmd>Octo issue list<cr>", desc = "List issues" },
      { "<leader>oio", "<cmd>Octo issue browser<cr>", desc = "Open issue in browser" },
      { "<leader>oiy", "<cmd>Octo issue url<cr>", desc = "Copy issue URL" },

      -- Paste
      { "<leader>oP", "<cmd>Octo !pbpaste<cr>", desc = "Octo (pbpaste)" },

      -- PRs
      { "<leader>op/", "<cmd>Octo pr search<cr>", desc = "Search prs" },
      { "<leader>opi", "<cmd>Octo pr create<cr>", desc = "Create pr" },
      { "<leader>opl", "<cmd>Octo pr list<cr>", desc = "List prs" },
      { "<leader>opo", "<cmd>Octo pr browser<cr>", desc = "Open pr in browser" },
      { "<leader>opy", "<cmd>Octo pr url<cr>", desc = "Copy pr URL" },
      { "<leader>opc", "<cmd>Octo pr commits<cr>", desc = "PR commits" },
      { "<leader>opd", "<cmd>Octo pr diff<cr>", desc = "PR diff" },

      -- review
      { "<leader>orC", "<cmd>Octo review comments<cr>", desc = "Pick commit" },
      { "<leader>orc", "<cmd>Octo review commit<cr>", desc = "View comments" },
      { "<leader>orD", "<cmd>Octo review discard<cr>", desc = "Discard pending review" },
      { "<leader>orr", "<cmd>Octo review resume<cr>", desc = "Resume review" },
      { "<leader>ors", "<cmd>Octo review start<cr>", desc = "Start review" },
      { "<leader>orS", "<cmd>Octo review submit<cr>", desc = "Submit review" },
      { "<leader>orX", "<cmd>Octo review close<cr>", desc = "Close review" },
    }
  end,
}
