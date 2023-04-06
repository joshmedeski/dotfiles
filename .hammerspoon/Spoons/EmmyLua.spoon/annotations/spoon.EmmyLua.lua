--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Thie plugin generates EmmyLua annotations for Hammerspoon and any installed Spoons
-- under ~/.hammerspoon/Spoons/EmmyLua.spoon/annotations.
-- Annotations will only be generated if they don't exist yet or are out of date.
--
-- Note: Load this Spoon before any pathwatchers are defined to avoid unintended behaviour (for example multiple reloads when the annotions are created).
--
-- In order to get auto completion in your editor, you need to have one of the following LSP servers properly configured:
-- * [lua-language-server](https://github.com/sumneko/lua-language-server) (recommended)
-- * [EmmyLua-LanguageServer](https://github.com/EmmyLua/EmmyLua-LanguageServer)
--
-- To start using this annotations library, add the annotations folder to your workspace.
-- for lua-languag-server:
--
-- ```json
-- {
--   "Lua.workspace.library": ["/Users/YOUR_USERNAME/.hammerspoon/Spoons/EmmyLua.spoon/annotations"]
-- }
-- ```
--
-- Download: [https://github.com/Hammerspoon/Spoons/raw/master/Spoons/EmmyLua.spoon.zip](https://github.com/Hammerspoon/Spoons/raw/master/Spoons/EmmyLua.spoon.zip)
---@class spoon.EmmyLua
local M = {}
spoon.EmmyLua = M

