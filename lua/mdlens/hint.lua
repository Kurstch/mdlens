local util = require("mdlens.util")
local File = require("mdlens.File")

local M = {}

local heading_ns = vim.api.nvim_create_namespace("mdlens_parent_heading")
local task_ns    = vim.api.nvim_create_namespace("mdlens_task")

---@param file File
function M.header(file)
    local curr_heading = file:current_heading()

    if curr_heading == nil then return end

    local references = curr_heading:find_all_references_to_self(file)

    vim.api.nvim_buf_set_extmark(0, heading_ns, curr_heading.line - 1, 0, {
        --virt_lines = {
        --    { { parent_headings, "MDLens" } },
        --    { { references .. " references", "MDLens" } },
        --},
        --virt_lines_above = true,
        virt_text = {
            { #references .. " references", "MDLens" }
        },
        virt_text_pos = "eol"
    })
end

---@param file File
function M.task(file)
    local line = vim.api.nvim_win_get_cursor(0)[1]
    local task = file.tasks[line]
    if task == nil or task.parent == nil then return end
    M.parent_task(file, task)
end

---@param file File
---@param task Task
function M.parent_task(file, task)
    local parent   = file.tasks[task.parent]
    local children = parent:children(file.tasks)
    local done     = 0
    for _, c in pairs(children) do if c.status == "x" then done = done + 1 end end

    vim.api.nvim_buf_set_extmark(0, task_ns, parent.line - 1, 0, {
        virt_text = {
            { done .. "/" .. #children .. " tasks done", "MDLens" }
        },
        virt_text_pos = "eol"
    })

    if parent.parent ~= nil then M.parent_task(file, parent) end
end

function M.hint()
    vim.api.nvim_buf_clear_namespace(0, heading_ns, 0, -1)
    vim.api.nvim_buf_clear_namespace(0, task_ns, 0, -1)

    local filepath = vim.api.nvim_buf_get_name(0)

    -- If file exists (is already analyzed) in workspaces,
    -- then use that rather than reanalyzing the file (reading using io.lines)
    -- This can save a lot of processing power
    local _, file = util.find_file_from_workspaces(filepath)

    if file == nil then
        file = File:analyze(filepath)
    end

    M.header(file)
    M.task(file)
end

return M
