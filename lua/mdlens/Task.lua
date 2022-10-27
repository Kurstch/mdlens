---@class Task
---@field filename string
---@field line     number
---@field indent   number
---@field status   string
---@field parent   number | nil
local Task = {}

Task.__index = function(_, k)
    local raw = rawget(Task, k)
    if raw then return raw end
end

---@param  filename string
---@param  line     number
---@param  indent   number
---@param  status   string
---@param  parent   number | nil
---@return Task
function Task:new(filename, line, indent, status, parent)
    local obj = {
        filename = filename,
        line     = line,
        indent   = indent,
        status   = status,
        parent   = parent,
    }

    setmetatable(obj, Task)

    return obj
end

---@param  filename string
---@param  tasks    tasks
---@param  line     number
---@param  text     string
---@return          Task | nil
function Task:analyze(filename, tasks, line, text)
    local whitespace, status = text:match("^(%s*)- %[(.)%]")
    if type(whitespace) ~= "string" or type(status) ~= "string" then return nil end

    local indent = whitespace:len()

    --Find parent task
    local parent = nil
    for _, t in pairs(tasks) do
        if t.line < line and t.indent < indent then
            if parent ~= nil then
                if parent.line < t.line then
                    parent = t
                end
            else
                parent = t
            end
        end
    end
    local parent_line = nil
    if parent ~= nil then parent_line = parent.line end

    return Task:new(filename, line, indent, status, parent_line)
end

---@param  tasks tasks
---@return       Task[]
function Task:children(tasks)
    local t = {}

    for _, task in pairs(tasks) do
        if task.parent == self.line then
            table.insert(t, task)
        end
    end

    return t
end

return Task
