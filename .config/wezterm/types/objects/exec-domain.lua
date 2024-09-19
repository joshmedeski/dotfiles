---@meta

--TODO: finish? fixup_function autocomplete not work when calling
-- think it is lua language server callback function param types issue

---@class ExecDomain
local ExecDomain = {}

---@param domain_name string
---@param fixup_function function(cmd: SpawnCommand): SpawnCommand
---@param label? string
ExecDomain.exec_domain = function(domain_name, fixup_function, label) end
