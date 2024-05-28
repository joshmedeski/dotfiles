local json = require("lua.json")
local hyper_key_rule = require("lua.hyper_key_rule")

local function write_json_file(file_path, data)
	local file = io.open(file_path, "w")
	if file == nil then
		error("Could not open file for writing: " .. file_path)
	end
	file:write(json.encode(data, { indent = true }))
	file:close()
end

local config = {
	global = { show_in_menu_bar = false },
	profiles = {
		{
			name = "Default",
			complex_modifications = {
				rules = {
					hyper_key_rule,
					{
						h = { to = { { key_code = "left_arrow" } } },
						j = { to = { { key_code = "down_arrow" } } },
						k = { to = { { key_code = "up_arrow" } } },
						l = { to = { { key_code = "right_arrow" } } },
					},
				},
			},
		},
	},
}

write_json_file("karabiner.json", config)
