if exists("g:loaded_vim_datedfiles")
    finish
endif
let g:loaded_vim_datedfiles = 1

function! s:new_with_fmt(root, fmt)
    let time=strftime(printf("%s", a:fmt))
    if exists('g:datedfile_default_header_format')
        let headertime=strftime(g:datedfile_default_header_format)
    else
        let headertime=strftime('%Y-%m-%d %A')
    endif
    let filename=expand(a:root . "/" . l:time . ".md")
    exec "e " . l:filename
    if !filereadable(l:filename)
        exec "norm i# " . headertime
    endif
    exec "norm G"
endfunction

function! s:new_or_jump(root)
    let root=printf("%s", a:root)
    if exists('g:datedfile_default_header_format')
        call s:new_with_fmt(l:root, g:datedfile_default_header_format)
    else
        call s:new_with_fmt(l:root, "%Y%m%d-%A")
    endif
endfunction

function! s:new_or_jump_with_fmt(root, ...)
    let root=printf("%s", a:root)
    let fmt=join(a:000, ' ')
    call s:new_with_fmt(l:root, l:fmt)
endfunction

command! -nargs=1 DatedFile call s:new_or_jump(<f-args>)
command! -nargs=+ DatedFileWithFmt call s:new_or_jump_with_fmt(<f-args>)
