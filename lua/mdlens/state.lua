---State is kept in a seperate file to avoid circular requires
local M = {}

---@type { [string]: Workspace }
M._workspaces = {}

return M
