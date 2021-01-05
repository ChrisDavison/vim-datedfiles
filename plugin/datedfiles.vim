if exists("g:loaded_vim_datedfiles")
    finish
endif
let g:loaded_vim_datedfiles = 1

function! s:new_with_fmt(root, fmt)
    let time=strftime(printf("%s", a:fmt))
    let timefmtheader="%Y-%m-%d %A"
    if exists('g:datedfile_default_header_format')
        let timefmtheader=g:datedfile_default_header_format
    endif
    let filename=expand(a:root . "/" . l:time . ".md")
    exec "e " . l:filename
    if !filereadable(l:filename)
        exec "norm i# " . strftime(l:timefmtheader)
    endif
    exec "norm G"
endfunction

function! s:new_or_jump(root)
    let root=printf("%s", a:root)
    let timefmt="%Y%m%d-%A"
    if exists('g:datedfile_default_format')
        let timefmt=g:datedfile_default_format
    endif
    call s:new_with_fmt(l:root, l:timefmt)
endfunction

function! s:new_or_jump_with_fmt(root, ...)
    let root=printf("%s", a:root)
    let fmt=join(a:000, ' ')
    call s:new_with_fmt(l:root, l:fmt)
endfunction

command! -nargs=1 DatedFile call s:new_or_jump(<f-args>)
command! -nargs=+ DatedFileWithFmt call s:new_or_jump_with_fmt(<f-args>)
