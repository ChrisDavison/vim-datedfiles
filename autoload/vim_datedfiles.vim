function! vim_datedfiles#new_with_fmt(root, fmt, ...)
    let tag=get(a:, 1, "")
    let time=strftime(printf("%s", a:fmt))
    let timefmtheader="%Y-%m-%d %A"
    if exists('g:datedfile_default_header_format')
        let timefmtheader=g:datedfile_default_header_format
    endif
    let filename=expand(a:root . "/" . l:time . ".md")
    if filereadable(l:filename)
        exec "edit " . l:filename
    else
        exec "edit " . l:filename
        let filename=expand('%:t:r')
        let words=split(l:filename, '\W\+')
        let titled=map(l:words, {_, word -> toupper(word[0]) . word[1:]})
        " call append(0, "# " . join(l:titled, ' '))
    endif
    exec "norm G"
endfunction

function! vim_datedfiles#new_or_jump(root)
    let root=printf("%s", a:root)
    let timefmt="%Y%m%d-%A"
    if exists('g:datedfile_default_format')
        let timefmt=g:datedfile_default_format
    endif
    call vim_datedfiles#new_with_fmt(l:root, l:timefmt)
endfunction

function! vim_datedfiles#new_or_jump_with_fmt(root, ...)
    let root=printf("%s", a:root)
    let fmt=join(a:000, ' ')
    call vim_datedfiles#new_with_fmt(l:root, l:fmt)
endfunction

