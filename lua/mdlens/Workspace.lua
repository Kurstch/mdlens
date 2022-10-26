local scan = require("plenary.scandir")
local File = require("mdlens.File")

---@class Workspace
---@field path string
---@field files { [string]: File }
local Workspace = {}

Workspace.__index = function(_, k)
    local raw = rawget(Workspace, k)
    if raw then return raw end
end

---@param path string
---@param files { [string]: File }
function Workspace.new(path, files)
    local obj = {
        path = path,
        files = files,
    }

    setmetatable(obj, Workspace)

    return obj
end

function Workspace:analyze(path)
    local scan_res = scan.scan_dir(path, {
        hidden = false,
        respect_gitignore = true,
        depth = 3,
        search_pattern = ".md"
    })

    local files = {}

    for _, filepath in pairs(scan_res) do
        files[filepath] = File:analyze(filepath)
    end

    return Workspace.new(path, files)
end

return Workspace
