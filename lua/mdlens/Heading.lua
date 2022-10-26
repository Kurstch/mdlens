local util = require("mdlens.util")

---Represents a heading in a markdown file.
---The parent field points to the line number of the parent heading (i.e. ## h2 > ## h1),
---it can be used as `next` in a linked list if headings are stored as { [number]: Heading }
---
---@class Heading
---@field line   number
---@field level  number
---@field text   string
---@field parent number | nil
local Heading = {}

Heading.__index = function(_, k)
    local raw = rawget(Heading, k)
    if raw then return raw end
end

---Create a new instance of the Heading class
---
---@param line   number       The line number where heading is in file
---@param level  number       The amount of `#` in the heading; it's level
---@param text   string       The heading text (i.e. "# heading text")
---@param parent number | nil The line number of the parent heading
---@return       Heading
function Heading:new(line, level, text, parent)
    local obj = {
        line = line,
        level = level,
        text = text,
        parent = parent,
    }

    setmetatable(obj, Heading)

    return obj
end

---Analyze the provided line and determine wether it is a heading.
---If it is, then analyze it.
---
---@param headings headings Previously analyzed heading for finding parent
---@param line     number
---@param text     string
---@return         Heading | nil
function Heading:analyze(headings, line, text)
    if util.starts_with(text, "#") then
        local _, _, signs = text:find("(#+)")
        local level = signs:len()

        --Find parent heading
        ---@type Heading | nil
        local parent = nil
        for _, h in pairs(headings) do
            if h.line < line and h.level < level then
                if parent ~= nil then
                    if parent.line < h.line then
                        parent = h
                    end
                else
                    parent = h
                end
            end
        end
        local parent_line = nil
        if parent ~= nil then parent_line = parent.line end

        return Heading:new(line, level, text, parent_line)
    end

    return nil
end

return Heading
