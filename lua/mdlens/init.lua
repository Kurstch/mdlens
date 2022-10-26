local state     = require("mdlens.state")
local Workspace = require("mdlens.Workspace")

local M = {}

function M.setup(config)
    if config.workspaces ~= nil then
        for _, path in ipairs(config.workspaces) do
            state._workspaces[path] = Workspace:analyze(path)
        end
    end
end

return M
