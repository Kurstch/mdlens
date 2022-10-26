local state = require("mdlens.state")

local M = {}

--- @param str string
--- @param start string
--- @return boolean
function M.starts_with(str, start)
    return str:sub(1, #start) == start
end

--- @param path string
--- @return string[]
function M.read_file(path)
    local lines = {}
    for line in io.lines(path) do
        lines[#lines + 1] = line
    end
    return lines
end

--- @param filepath string
--- @return Workspace, File | nil, nil
function M.find_file_from_workspaces(filepath)
    for _, w in pairs(state._workspaces) do
        local file = w[filepath]
        if file ~= nil then return w, file end
    end
    return nil, nil
end

return M
