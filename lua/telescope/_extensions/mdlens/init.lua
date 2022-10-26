
local telescope_installed, telescope = pcall(require, "telescope")

if not telescope_installed then
    error("Telescope is not installed")
end

local finders = require("telescope.finders")
local previewer = require("telescope.previewers")
local Picker = require("telescope.pickers")
local File = require("mdlens.File")
local util = require("mdlens.util")

local function mdlens_heading_links()
    local filepath = vim.api.nvim_buf_get_name(0)
    local _, file = util.find_file_from_workspaces(filepath)
    if file == nil then file = File:analyze(filepath) end

    local current_heading = file:current_heading()

    if current_heading == nil then
        vim.notify("no heading")
        return
    end

    Picker:new({
        previewer = previewer.vim_buffer_vimgrep:new(),
        finder    = finders.new_table({
            results = current_heading:find_all_references_to_self(file),
            ---@param entry Link
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = entry.filepath .. ":" .. entry.line,
                    ordinal = entry.filepath .. ":" .. entry.line,
                    filename = entry.filepath,
                    lnum = entry.line,
                }
            end
        })
    }):find()
end

return telescope.register_extension({
    exports = {
        heading_links = mdlens_heading_links,
    }
})
