function! s:filename(root, fmt, name) abort "{{{
    let time=strftime(printf("%s", a:fmt))
        let name=""
    if a:name != ""
        let name="-" . substitute(a:name, " ", "-", "g")
    endif
    let filename=expand(a:root . "/" . l:time . l:name . ".md")
    return substitute(l:filename, "//", "/", "g")
endfunction "}}}

function! s:titlecase(sentence) abort "{{{
    let words=split(a:sentence, '\W\+')
    let titled=map(l:words, {_, word -> toupper(word[0]) . word[1:]})
    return join(l:titled, ' ')
endfunction "}}}

function! vim_datedfiles#new_with_fmt(root, fmt, ...) abort "{{{
    let filename=s:filename(a:root, a:fmt, '')
    if filereadable(l:filename)
        exec "edit " . l:filename
    else
        if exists('g:markdown_filename_as_header_suppress')
            let suppress=g:markdown_filename_as_header_suppress
            let g:markdown_filename_as_header_suppress=1
            exec "edit " . l:filename
            let timefmtheader="%Y-%m-%d %A"
            if exists('g:datedfile_default_header_format')
                let timefmtheader=g:datedfile_default_header_format
            endif

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
endfunction "}}}

function! vim_datedfiles#new_with_fmt_and_name(root, fmt, name) abort "{{{
    let filename=s:filename(a:root, a:fmt, a:name)
    if filereadable(l:filename)
        exec "edit " . l:filename
    else
        let folder=fnamemodify(l:filename, ":p:h")
        if !isdirectory(l:folder)
            call mkdir(l:folder, "p")
        endif
        if exists('g:markdown_filename_as_header_suppress')
            let suppress=g:markdown_filename_as_header_suppress
            let g:markdown_filename_as_header_suppress=1
            exec "edit " . l:filename
            call append(0, "# " . <sid>titlecase(a:name))
            call append(1, ["", "Timestamp: " . strftime("%Y%m%dT%H%M")])
            let g:markdown_filename_as_header_suppress=l:suppress
        else
            let filename=expand('%:t:r')
            exec "edit " . l:filename
            call append(0, "# " . <sid>titlecase(l:filename))
        endif
    endif
    exec "norm G"
endfunction "}}}

function! vim_datedfiles#new_or_jump(root) abort "{{{
    let root=printf("%s", a:root)
    call vim_datedfiles#new_with_fmt(l:root, g:datedfile_default_format)
endfunction "}}}

function! vim_datedfiles#new_or_jump_with_fmt(root, ...) abort "{{{
    let root=printf("%s", a:root)
    let fmt=join(a:000, ' ')
    call vim_datedfiles#new_with_fmt(l:root, l:fmt)
endfunction "}}}

