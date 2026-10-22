return {
  "stevearc/oil.nvim",
  opts = {},
  dependencies = { { "nvim-mini/mini.icons", opts = {} } },
  lazy = false,
  config = function()
    _G.my_oil_winbar = function()
      local dir = require("oil").get_current_dir()
      if dir then
        local cwd = vim.fn.getcwd()

        local handle = io.popen("df -h '" .. cwd .. "' 2>/dev/null | tail -1 | awk '{print $4, $3}'")
        local disk_space = "Unknown"

        if handle then
          local result = handle:read("*a")
          handle:close()

          result = result:gsub("\n", "")

          local avail, used = result:match("([^%s]+)%s+([^%s]+)")

          if avail and used then
            disk_space = avail .. " available (" .. used .. " used)"
          end
        end

        return "    " .. vim.fn.fnamemodify(dir, ":~") .. "     " .. disk_space
      end
      return "    Oil Explorer"
    end
    require("oil").setup({
      default_file_explorer = true,
      columns = {
        "icon",
        "permissions",
        "size",
        "mtime",
      },

      win_options = {
        winbar = "%!v:lua.my_oil_winbar()",
      },

      view_options = {
        show_hidden = true,
        natural_order = true,
      },
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
      keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",

        ["q"] = "actions.close",
        ["<C-c>"] = "actions.close",
        ["R"] = "actions.refresh",
      },
    })

    vim.api.nvim_set_keymap("n", "<leader>e", ":Oil<cr>", {})
  end,
}
