local M = {}

M.without_ds_store = function(tbl)
	local cleaned_tbl = {}
	for _, v in ipairs(tbl) do
		if not string.match(v, ".DS_Store") then
			table.insert(cleaned_tbl, v)
		end
	end
	return cleaned_tbl
end

return M
