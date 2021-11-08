function! vim_datedfiles#new_with_fmt(root, fmt, ...) abort
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
        if exists('g:markdown_filename_as_header_suppress')
            let suppress=g:markdown_filename_as_header_suppress
            let g:markdown_filename_as_header_suppress=1
            exec "edit " . l:filename
            call append(0, "# " . strftime(timefmtheader))
            let g:markdown_filename_as_header_suppress=l:suppress
        else
            let filename=expand('%:t:r')
            let words=split(l:filename, '\W\+')
            let titled=map(l:words, {_, word -> toupper(word[0]) . word[1:]})
            exec "edit " . l:filename
            call append(0, "# " . join(l:titled, ' '))
        endif
    endif
    exec "norm G"
endfunction

function! vim_datedfiles#new_with_fmt_and_name(root, fmt, name) abort
    let tag=get(a:, 1, "")
    let time=strftime(printf("%s", a:fmt))
    let timefmtheader="%Y-%m-%d %A"
    if exists('g:datedfile_default_header_format')
        let timefmtheader=g:datedfile_default_header_format
    endif
    let name=substitute(a:name, " ", "-", "g")
    let filename=expand(a:root . "/" . l:time . "-" . l:name . ".md")
    if filereadable(l:filename)
        exec "edit " . l:filename
    else
        let folder=fnamemodify(a:filename, ":p:h")
        if !isdirectory(l:folder)
            call mkdir(l:folder, "p")
        endif
        if exists('g:markdown_filename_as_header_suppress')
            let suppress=g:markdown_filename_as_header_suppress
            let g:markdown_filename_as_header_suppress=1
            exec "edit " . l:filename
            call append(0, "# " . strftime(timefmtheader))
            let g:markdown_filename_as_header_suppress=l:suppress
        else
            let filename=expand('%:t:r')
            let words=split(l:filename, '\W\+')
            let titled=map(l:words, {_, word -> toupper(word[0]) . word[1:]})
            exec "edit " . l:filename
            call append(0, "# " . join(l:titled, ' '))
        endif
    endif
    exec "norm G"

endfunction

function! vim_datedfiles#new_or_jump(root) abort
    let root=printf("%s", a:root)
    let timefmt="%Y%m%d-%A"
    if exists('g:datedfile_default_format')
        let timefmt=g:datedfile_default_format
    endif
    call vim_datedfiles#new_with_fmt(l:root, l:timefmt)
endfunction

function! vim_datedfiles#new_or_jump_with_fmt(root, ...) abort
    let root=printf("%s", a:root)
    let fmt=join(a:000, ' ')
    call vim_datedfiles#new_with_fmt(l:root, l:fmt)
endfunction

