highlight default link MDLens Comment

autocmd CursorMoved  *.md lua require("mdlens.hint").hint()
autocmd CursorMovedI *.md lua require("mdlens.hint").hint()
