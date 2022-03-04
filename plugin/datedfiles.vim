if exists("g:loaded_vim_datedfiles")
    finish
endif
let g:loaded_vim_datedfiles = 1

if !exists("g:datedfile_default_format")
    let g:datedfile_default_format="%Y-%m-%d-%A"
endif

if !exists("g:datedfile_default_header_format")
    let g:datedfile_default_header_format="%Y-%m-%d %A"
endif

command! -nargs=1 DatedFile call vim_datedfiles#new_or_jump(<f-args>)
command! -nargs=+ DatedFileWithFmt call vim_datedfiles#new_or_jump_with_fmt(<f-args>)
