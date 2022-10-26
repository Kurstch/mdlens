local util = require("mdlens.util")
local File = require("mdlens.File")

local M = {}

local heading_ns = vim.api.nvim_create_namespace("mdlens_parent_heading")

---@param curr_heading Heading
---@param file File
function M.header(curr_heading, file)
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

function M.hint()
    vim.api.nvim_buf_clear_namespace(0, heading_ns, 0, -1)

    local filepath = vim.api.nvim_buf_get_name(0)

    -- If file exists (is already analyzed) in workspaces,
    -- then use that rather than reanalyzing the file (reading using io.lines)
    -- This can save a lot of processing power
    local _, file = util.find_file_from_workspaces(filepath)

    if file == nil then
        file = File:analyze(filepath)
    end

    local curr_heading = file:current_heading()

    if curr_heading == nil then return end

    M.header(curr_heading, file)
end

return M
