local util      = require("mdlens.util")
local state     = require("mdlens.state")
local File      = require("mdlens.File")
local Workspace = require("mdlens.Workspace")

local M = {}

function M.setup(config)
    if config.workspaces ~= nil then
        for _, path in ipairs(config.workspaces) do
            state._workspaces[path] = Workspace:analyze(path)
        end
    end
end

function M.reload_current_file()
    local filepath        = vim.api.nvim_buf_get_name(0)
    local worksapce, file = util.find_file_from_workspaces(filepath)

    if file == nil then return end

    state._workspaces[worksapce.path].files[file.filepath] = File:analyze(file.filepath)
end

return M
