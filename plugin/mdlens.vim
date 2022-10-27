highlight default link MDLens Comment

autocmd BufWritePost *.md lua require("mdlens").reload_current_file()
autocmd CursorMoved  *.md lua require("mdlens.hint").hint()
autocmd CursorMovedI *.md lua require("mdlens.hint").hint()
