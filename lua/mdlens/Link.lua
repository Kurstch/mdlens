local util = require("mdlens.util")

---Represents a markdown link
---
---@class Link
---@field href     string
---@field filepath string
---@field line     number
local Link = {}

Link.__index = function(_, k)
    local raw = rawget(Link, k)
    if raw then return raw end
end

---Convert any relative path in the link to an absolute one
---
---@param  filepath string Absolute path to the file the link is in
---@param  href     string
---@return          string
local function aboslute(filepath, href)
    local absolute = href
    local dir_path = filepath:match("(.+/).+%.md$")

    if util.starts_with(absolute, "./") then
        absolute = absolute:gsub("./", dir_path)
    elseif util.starts_with(absolute, "../") then
        local parent_dir_path = dir_path:match("(.+/).+$")
        absolute = absolute:gsub("../", parent_dir_path)
    elseif util.starts_with(absolute, "~/") then
        local home_dir = os.getenv("HOME") --[[@as string]]
        absolute = absolute:gsub("~/", home_dir .. "/")
    end

    return absolute
end

---Create a new instance of the Link class
---
---@param  line number
---@param  href string
---@return Link
function Link:new(filepath, line, href)
    local obj = {
        filepath = filepath,
        line = line,
        href = aboslute(filepath, href),
    }

    setmetatable(obj, Link)

    return obj
end

---Tries to find a link in the given line text.
---If it has a link, then returns a Link class, otherwise nil.
---
---@param  filepath string
---@param  line     number
---@param  text     string
---@return          Link | nil
function Link:analyze(filepath, line, text)
    local link, href = text:match("(%[.+%]%((.+)%))")
    if link ~= nil then
        return Link:new(filepath, line, href)
    end
    return nil
end

---Checks wether this link is pointing to a heading
---
---@param  filepath string  The file where the heading is located
---@param  heading  Heading The heading text
---@return boolean
function Link:points_to_heading(filepath, heading)
    local path, header = self.href:match("(.*)(#.+)")

    if header == nil then return false end
    if path:len() ~= 0 and path ~= filepath then return false end

    local heading_text = heading:normalize()

    if header == heading_text then return true end

    return false
end

return Link
