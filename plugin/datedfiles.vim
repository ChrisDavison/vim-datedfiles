if exists("g:loaded_vim_datedfiles")
    finish
endif
let g:loaded_vim_datedfiles = 1
let g:datedfile_default_format="%Y-%m-%d-%A"

command! -nargs=1 DatedFile call vim_datedfiles#new_or_jump(<f-args>)
command! -nargs=+ DatedFileWithFmt call vim_datedfiles#new_or_jump_with_fmt(<f-args>)
