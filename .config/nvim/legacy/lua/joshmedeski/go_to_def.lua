local M = {}

-- filters out typescript `*.d.ts` files
local function filter_dts(value)
  return string.match(value.filename, "%.d.ts") == nil
end

local function filter(arr, fn)
  if type(arr) ~= "table" then
    return arr
  end

  local filtered = {}
  for k, v in pairs(arr) do
    if fn(v, k, arr) then
      table.insert(filtered, v)
    end
  end

  return filtered
end

local function on_list(options)
  -- https://github.com/typescript-language-server/typescript-language-server/issues/216
  local items = options.items
  if #items > 1 then
    items = filter(items, filter_dts)
  end

  vim.fn.setqflist({}, " ", { title = options.title, items = items, context = options.context })
  vim.api.nvim_command("cfirst")
end

M.go_to_def = function()
  vim.lsp.buf.definition({ on_list = on_list })
end

return M
