---@meta

--TODO:? make key and mods more specific

---@alias KeyAssignment "ActivateCommandPalette" | "ActivateCopyMode" | "ActivateKeyTable" | "ActivateLastTab" | "ActivatePaneByIndex" | "ActivatePaneDirection" | "ActivateTab" | "ActivateTabRelative" | "ActivateTabRelativeNoWrap" | "ActivateWindow" | "ActivateWindowRelative" | "ActivateWindowRelativeNoWrap" | "AdjustPaneSize" | "AttachDomain" | "CharSelect" | "ClearKeyTableStack" | "ClearScrollback" | "ClearSelection" | "CloseCurrentPane" | "CloseCurrentTab" | "CompleteSelection" | "CompleteSelectionOrOpenLinkAtMouseCursor" | "Copy" | "CopyTo" | "DecreaseFontSize" | "DetachDomain" | "DisableDefaultAssignment" | "EmitEvent" | "ExtendSelectionToMouseCursor" | "Hide" | "HideApplication" | "IncreaseFontSize" | "InputSelector" | "MoveTab" | "MoveTabRelative" | "Multiple" | "Nop" | "OpenLinkAtMouseCursor" | "PaneSelect" | "Paste" | "PasteFrom" | "PastePrimarySelection" | "PopKeyTable" | "PromptInputLine" | "QuickSelect" | "QuickSelectArgs" | "QuitApplication" | "ReloadConfiguration" | "ResetFontAndWindowSize" | "ResetFontSize" | "ResetTerminal" | "RotatePanes" | "ScrollByCurrentEventWheelDelta" | "ScrollByLine" | "ScrollByPage" | "ScrollToBottom" | "ScrollToPrompt" | "ScrollToTop" | "Search" | "SelectTextAtMouseCursor" | "SendKey" | "SendString" | "SetPaneZoomState" | "Show" | "ShowDebugOverlay" | "ShowLauncher" | "ShowLauncherArgs" | "ShowTabNavigator" | "SpawnCommandInNewTab" | "SpawnCommandInNewWindow" | "SpawnTab" | "SpawnWindow" | "SplitHorizontal" | "SplitPane" | "SplitVertical" | "StartWindowDrag" | "SwitchToWorkspace" | "SwitchWorkspaceRelative" | "ToggleFullScreen" | "TogglePaneZoomState"

---@class KeyNoAction
---@field key string
---@field mods? string

---@class Key :KeyNoAction
---@field action KeyAssignment

---@class Action can also be called as function like older versions of wezterm did
local Action = {}

---@return KeyAssignment
Action.ActivateCommandPalette = function(param) end
---@return KeyAssignment
Action.ActivateCopyMode = function(param) end
---@return KeyAssignment
Action.ActivateKeyTable = function(param) end
---@return KeyAssignment
Action.ActivateLastTab = function(param) end
---@return KeyAssignment
Action.ActivatePaneByIndex = function(param) end
---@return KeyAssignment
Action.ActivatePaneDirection = function(param) end
---@return KeyAssignment
Action.ActivateTab = function(param) end
---@return KeyAssignment
Action.ActivateTabRelative = function(param) end
---@return KeyAssignment
Action.ActivateTabRelativeNoWrap = function(param) end
---@return KeyAssignment
Action.ActivateWindow = function(param) end
---@return KeyAssignment
Action.ActivateWindowRelative = function(param) end
---@return KeyAssignment
Action.ActivateWindowRelativeNoWrap = function(param) end
---@return KeyAssignment
Action.AdjustPaneSize = function(param) end
---@return KeyAssignment
Action.AttachDomain = function(param) end
---@return KeyAssignment
Action.CharSelect = function(param) end
---@return KeyAssignment
Action.ClearKeyTableStack = function(param) end
---@return KeyAssignment
Action.ClearScrollback = function(param) end
---@return KeyAssignment
Action.ClearSelection = function(param) end
---@return KeyAssignment
Action.CloseCurrentPane = function(param) end
---@return KeyAssignment
---@param param {confirm: boolean}
Action.CloseCurrentTab = function(param) end
---@return KeyAssignment
Action.CompleteSelection = function(param) end
Action.CompleteSelectionOrOpenLinkAtMouseCursor = function(param) end
---@return KeyAssignment
Action.Copy = function(param) end
---@return KeyAssignment
Action.CopyTo = function(param) end
---@return KeyAssignment
Action.DecreaseFontSize = function(param) end
---@return KeyAssignment
Action.DetachDomain = function(param) end
---@return KeyAssignment
Action.DisableDefaultAssignment = function(param) end
---@return KeyAssignment
Action.EmitEvent = function(param) end
---@return KeyAssignment
Action.ExtendSelectionToMouseCursor = function(param) end
---@return KeyAssignment
Action.Hide = function(param) end
---@return KeyAssignment
Action.HideApplication = function(param) end
---@return KeyAssignment
Action.IncreaseFontSize = function(param) end
---@return KeyAssignment
Action.InputSelector = function(param) end
---@return KeyAssignment
Action.MoveTab = function(param) end
---@return KeyAssignment
Action.MoveTabRelative = function(param) end
---@return KeyAssignment
Action.Multiple = function(param) end
---@return KeyAssignment
Action.Nop = function(param) end
---@return KeyAssignment
Action.OpenLinkAtMouseCursor = function(param) end
---@return KeyAssignment
Action.PaneSelect = function(param) end
---@return KeyAssignment
Action.Paste = function(param) end
---@return KeyAssignment
Action.PasteFrom = function(param) end
---@return KeyAssignment
Action.PastePrimarySelection = function(param) end
---@return KeyAssignment
Action.PopKeyTable = function(param) end
---@return KeyAssignment
Action.PromptInputLine = function(param) end
---@return KeyAssignment
Action.QuickSelect = function(param) end
---@return KeyAssignment
Action.QuickSelectArgs = function(param) end
---@return KeyAssignment
Action.QuitApplication = function(param) end
---@return KeyAssignment
Action.ReloadConfiguration = function(param) end
---@return KeyAssignment
Action.ResetFontAndWindowSize = function(param) end
---@return KeyAssignment
Action.ResetFontSize = function(param) end
Action.ResetTerminal = function(param) end
---@return KeyAssignment
Action.RotatePanes = function(param) end
---@return KeyAssignment
Action.ScrollByCurrentEventWheelDelta = function(param) end
---@return KeyAssignment
Action.ScrollByLine = function(param) end
---@return KeyAssignment
Action.ScrollByPage = function(param) end
---@return KeyAssignment
Action.ScrollToBottom = function(param) end
---@return KeyAssignment
Action.ScrollToPrompt = function(param) end
---@return KeyAssignment
Action.ScrollToTop = function(param) end
---@return KeyAssignment
Action.Search = function(param) end
---@return KeyAssignment
Action.SelectTextAtMouseCursor = function(param) end
---@return KeyAssignment
Action.SendKey = function(param) end
---@return KeyAssignment
Action.SendString = function(param) end
---@return KeyAssignment
Action.SetPaneZoomState = function(param) end
---@return KeyAssignment
Action.Show = function(param) end
---@return KeyAssignment
Action.ShowDebugOverlay = function(param) end
---@return KeyAssignment
Action.ShowLauncher = function(param) end
---@return KeyAssignment
Action.ShowLauncherArgs = function(param) end
---@return KeyAssignment
Action.ShowTabNavigator = function(param) end
---@return KeyAssignment
Action.SpawnCommandInNewTab = function(param) end
---@return KeyAssignment
Action.SpawnCommandInNewWindow = function(param) end
---@return KeyAssignment
Action.SpawnTab = function(param) end
---@return KeyAssignment
Action.SpawnWindow = function(param) end
---@return KeyAssignment
Action.SplitHorizontal = function(param) end
---@return KeyAssignment
Action.SplitPane = function(param) end
---@return KeyAssignment
Action.SplitVertical = function(param) end
---@return KeyAssignment
Action.StartWindowDrag = function(param) end
---@return KeyAssignment
Action.SwitchToWorkspace = function(param) end
---@return KeyAssignment
Action.SwitchWorkspaceRelative = function(param) end
---@return KeyAssignment
Action.ToggleFullScreen = function(param) end
---@return KeyAssignment
Action.TogglePaneZoomState = function(param) end
