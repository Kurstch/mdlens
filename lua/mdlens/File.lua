local util    = require("mdlens.util")
local Heading = require("mdlens.Heading")

---@alias headings
---| { [number]: Heading }

---@class File
---@field filepath string
---@field headings headings
local File = {}

File.__index = function(_, k)
    local raw = rawget(File, k)
    if raw then return raw end
end

---@param filepath string
---@param headings headings
function File:new(filepath, headings)
    local obj = {
        filepath = filepath,
        headings = headings,
    }

    setmetatable(obj, File)

    return obj
end

--- Finds all headings in the given file
--- @param lines string[] An array of lines from the file, you can use `io.lines()`
--- @return headings
local function find_headings(lines)
    local headings = {}

    for line, text in pairs(lines) do
        local heading = Heading:analyze(headings, line, text)
        if heading ~= nil then headings[line] = heading end
    end

    return headings
end

function File:analyze(filepath)
    local lines = util.read_file(filepath)
    local headings = find_headings(lines)
    return File:new(filepath, headings)
end

return File
