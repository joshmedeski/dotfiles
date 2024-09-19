---@meta

--TODO: finish

---@class ColorMod
---@field parse fun(color: string): Color?
local color = {}

---@param filename string
---@param params? { fuzziness: number, num_colors: number, max_width: number, max_height: number, min_brightness: number, max_brightness: number, threshold: number, min_contrast: number }
function color.extract_colors_from_image(filename, params) end

---@param h string | number
---@param s string | number
---@param l string | number
---@param a string | number
---@return ColorMod
function color.from_hsla(h, s, l, a) end

---@return table<string, Palette>
function color.get_builtin_schemes() end

---@return Palette
function color.get_default_colors() end

---@param gradient Gradient
---@param num_colors number
---@return Color[]
function color.gradient(gradient, num_colors) end

---@param file_name string
---@return Palette, ColorSchemeMetaData
function color.load_base16_scheme(file_name) end

---@param file_name string
---@return Palette, ColorSchemeMetaData
function color.load_scheme(file_name) end

---@param file_name string
---@return Palette, ColorSchemeMetaData
function color.load_terminal_sexy_scheme(file_name) end

---@param string string
---@return Color
-- Parses the passed color and returns a Color object. Color objects evaluate as strings but have a number of methods that allow transforming and comparing colors.
function color.parse(string) end

---@param colors Palette
---@param metadata ColorSchemeMetaData
---@param file_name string
function color.save_scheme(colors, metadata, file_name) end
