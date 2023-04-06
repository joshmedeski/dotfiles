--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Interact with SQLite databases
--
-- Notes:
--  * This module is LSQLite 0.9.5 as found at http://lua.sqlite.org/index.cgi/index
--  * It is unmodified apart from removing `db:load_extension()` as this feature is not available in Apple's libsqlite3.dylib
--  * For API documentation please see [http://lua.sqlite.org](http://lua.sqlite.org)
---@class hs.sqlite3
local M = {}
hs.sqlite3 = M

