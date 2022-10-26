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

return M
