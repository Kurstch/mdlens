---@class File
---@field filepath string
local File = {}

File.__index = function(_, k)
    local raw = rawget(File, k)
    if raw then return raw end
end

---@param filepath string
function File:new(filepath)
    local obj = {
        filepath = filepath,
    }

    setmetatable(obj, File)

    return obj
end

return File
