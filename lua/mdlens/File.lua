local util    = require("mdlens.util")
local Link    = require("mdlens.Link")
local Heading = require("mdlens.Heading")
local Task    = require("mdlens.Task")

---@alias headings
---| { [number]: Heading }
---@alias links
---| { [number]: Link }
---@alias tasks
---| { [number]: Task }

---@class File
---@field filepath string
---@field headings headings
---@field links    links
---@field tasks    tasks
local File = {}

File.__index = function(_, k)
    local raw = rawget(File, k)
    if raw then return raw end
end

---@param  filepath string
---@param  headings headings
---@param  links    links
---@param  tasks    tasks
---@return File
function File:new(filepath, headings, links, tasks)
    local obj = {
        filepath = filepath,
        headings = headings,
        links    = links,
        tasks    = tasks,
    }

    setmetatable(obj, File)

    return obj
end

function File:analyze(filepath)
    local lines = util.read_file(filepath)
    local headings = {}
    local links = {}
    local tasks = {}

    for line, text in pairs(lines) do
        local heading = Heading:analyze(headings, line, text)
        local link    = Link:analyze(filepath, line, text)
        local task    = Task:analyze(filepath, tasks, line, text)

        if heading ~= nil then headings[line] = heading end
        if link ~= nil then links[line] = link end
        if task ~= nil then tasks[line] = task end
    end

    return File:new(filepath, headings, links, tasks)
end

---@return Heading | nil
function File:current_heading()
    local current_line    = vim.api.nvim_win_get_cursor(0)[1]
    local current_heading = nil

    for _, h in pairs(self.headings) do
        if h.line <= current_line then
            if current_heading ~= nil then
                if current_heading.line < h.line then current_heading = h end
            else current_heading = h end
        end
    end

    return current_heading
end

return File
